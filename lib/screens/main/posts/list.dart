import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/post_model.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/services/posts.dart';
import 'package:twitter/services/user.dart';

class ListPosts extends StatefulWidget {
  ListPosts({Key key}) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  UserService _userService = UserService();
  PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>>(context);

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final post = posts[i];

        return StreamBuilder(
          stream: _userService.getUserInfo(post.creator),
          builder:
              (BuildContext context, AsyncSnapshot<UserModel> snapshotUser) {
            if (!snapshotUser.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return StreamBuilder(
              stream: _postService.getCurrentLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                if (!snapshotLike.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: snapshotUser.data.profileImageUrl != ''
                            ? CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                    snapshotUser.data.profileImageUrl),
                              )
                            : Icon(
                                Icons.person,
                                size: 30,
                              ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        snapshotUser.data.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              post.text,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(post.timestamp.toDate().toString()),
                            SizedBox(
                              height: 20,
                            ),
                            IconButton(
                                icon: new Icon(
                                  snapshotLike.data
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  _postService.likePost(post, true);
                                })
                          ],
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
