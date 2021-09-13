import 'package:flutter/material.dart';
import 'package:twitter/services/posts.dart';

class Add extends StatefulWidget {
  Add({Key key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  String text = '';
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Tweet',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _postService.savePost(text);
                Navigator.pop(context);
              },
              child: Text(
                'Tweet',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: TextFormField(
            onChanged: (val) {
              text = val;
            },
          ),
        ));
  }
}
