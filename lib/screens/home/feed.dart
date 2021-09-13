import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/main/posts/list.dart';
import 'package:twitter/services/posts.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(
      value: _postService.getFeed(),
      initialData: null,
      child: Scaffold(
        body: ListPosts(),
      ),
    );
  }
}
