import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/models/post_model.dart';
import 'package:twitter/services/user.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel> _postFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
          id: doc.id,
          creator: doc["creator"] ?? '',
          text: doc['text'] ?? '',
          timestamp: doc['timestamp'] ?? 0);
    }).toList();
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Stream<bool> getCurrentLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future likePost(PostModel post, bool current) async {
    print(post.id);
    if (current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();
    }
    if (!current) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({});
    }
  }

  Stream<List<PostModel>> getPostList(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where("creator", isEqualTo: uid)
        .snapshots()
        .map(_postFromDatabase);
  }

  Future<List<PostModel>> getFeed() async {
    List<String> _usreFollowing = await UserService()
        .getUsersFollowing(FirebaseAuth.instance.currentUser.uid);

    List<PostModel> feedList = [];

    //partition came from quiver which is used to handle array of arrays

    var _splitUsersFollowing = partition<dynamic>(_usreFollowing, 10);

    for (int i = 0; i < _splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: _splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postFromDatabase(querySnapshot));
    }
    feedList.sort((a, b) {
      final adate = a.timestamp;
      final bdate = b.timestamp;

      return bdate.compareTo(adate);
    });
    return feedList;
  }
}
