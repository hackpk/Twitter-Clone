import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/services/user.dart';

class Edit extends StatefulWidget {
  Edit({Key key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  UserService _userService = UserService();
  File _bannerImage;
  File _profileImage;
  String name = '';
  final picker = ImagePicker();

  Future getImage(int type) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print(pickedFile.path);
    setState(() {
      if (_bannerImage == null && type == 1) {
        _bannerImage = File(pickedFile.path);
      }
      if (_profileImage == null && type == 0) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await _userService.updateProfile(
                  _profileImage, _bannerImage, name);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          child: Column(
            children: <Widget>[
              TextButton(
                onPressed: () => getImage(0),
                child: _profileImage == null
                    ? Icon(Icons.person)
                    : Image.file(
                        _profileImage,
                        height: 100,
                      ),
              ),
              TextButton(
                onPressed: () => getImage(1),
                child: _bannerImage == null
                    ? Icon(Icons.person)
                    : Image.file(
                        _bannerImage,
                        height: 100,
                      ),
              ),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
