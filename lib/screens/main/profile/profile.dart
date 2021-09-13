import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:twitter/models/post_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/screens/main/posts/list.dart';
import 'package:twitter/services/posts.dart';
import 'package:twitter/services/user.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context).settings.arguments;
    // final user = Provider.of<UserModel>(context);

    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: _userService.isFollowing(
                FirebaseAuth.instance.currentUser.uid, uid),
            initialData: null),
        StreamProvider.value(
            value: _postService.getPostList(uid), initialData: null),
        StreamProvider.value(
          initialData: null,
          value: _userService.getUserInfo(uid),
        )
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return <Widget>[
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  expandedHeight: 150.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      Provider.of<UserModel>(context).bannerImageUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Provider.of<UserModel>(context)
                                            .profileImageUrl !=
                                        ''
                                    ? CircleAvatar(
                                        radius: 45,
                                        backgroundImage: NetworkImage(
                                            Provider.of<UserModel>(context)
                                                .profileImageUrl),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 20,
                                      ),
                                // TextButton(
                                //     onPressed: () {
                                //       Navigator.pushNamed(context, '/edit');
                                //     },
                                //     child: Text('Edit Profile'))

                                if (FirebaseAuth.instance.currentUser.uid ==
                                    uid)
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/edit');
                                      },
                                      child: Text('Edit Profile'))
                                else if (FirebaseAuth
                                            .instance.currentUser.uid !=
                                        uid &&
                                    !Provider.of<bool>(context))
                                  TextButton(
                                      onPressed: () {
                                        _userService.follow(uid);
                                      },
                                      child: Text('Follow'))
                                else if (FirebaseAuth
                                            .instance.currentUser.uid !=
                                        uid &&
                                    Provider.of<bool>(context))
                                  TextButton(
                                      onPressed: () {
                                        _userService.unfollow(uid);
                                      },
                                      child: Text('UnFollow'))
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  Provider.of<UserModel>(context).name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ];
            },
            body: ListPosts(),
          ),
        ),
      ),
    );
  }
}
