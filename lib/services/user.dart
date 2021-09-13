import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/services/utils.dart';

class UserService {
  UtilsService _utilsService = UtilsService();

  //get users based on the search
  List<UserModel> _userListFromQueryByName(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel(
        id: doc.id,
        name: doc['name'] ?? '',
        email: doc['email'] ?? '',
        bannerImageUrl: doc['bannerImageUrl'] ?? '',
        profileImageUrl: doc['profileImageUrl'] ?? '',
      );
    }).toList();
  }
//search user on database based on searchtext

  Stream<List<UserModel>> serchUsers(search) {
    return FirebaseFirestore.instance
        .collection("users")
        .orderBy("name")
        .startAt([search])
        .endAt([search + '\uf8ff'])
        .limit(10)
        .snapshots()
        .map(_userListFromQueryByName);
  }

  UserModel _userfromFirebase(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            name: snapshot['name'] ?? '',
            email: snapshot['email'] ?? '',
            bannerImageUrl: snapshot['bannerImageUrl'] ?? '',
            profileImageUrl: snapshot['profileImageUrl'] ?? '',
          )
        : null;
  }

  Future<List<String>> getUsersFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();
    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    // print(users.length);
    return users;
  }

  Stream<UserModel> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_userfromFirebase);
  }

  Stream<bool> isFollowing(uid, otherId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(otherId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<void> follow(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("following")
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({});
  }

  Future<void> unfollow(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("following")
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete();
  }

  Future<void> updateProfile(
      File _profileImage, File _bannerImage, String name) async {
    String profileImageUrl = '';
    String bannerImageUrl = '';

    if (_profileImage != null) {
      //save the image in database
      profileImageUrl = await _utilsService.uploadFile(_profileImage,
          'user/profile/${FirebaseAuth.instance.currentUser.uid}/profile');
    }
    if (_bannerImage != null) {
      //save the image in database
      bannerImageUrl = await _utilsService.uploadFile(_bannerImage,
          'user/profile/${FirebaseAuth.instance.currentUser.uid}/banner');
    }

    Map<String, Object> data = new HashMap();
    if (name != '') data['name'] = name;
    if (profileImageUrl != '') data['profileImageUrl'] = profileImageUrl;
    if (bannerImageUrl != '') data['bannerImageUrl'] = bannerImageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(data);
  }
}
