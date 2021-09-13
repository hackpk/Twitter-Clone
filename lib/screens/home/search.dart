import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/main/profile/list.dart';
import 'package:twitter/services/user.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserService _userService = UserService();
  String search = '';

  @override
  Widget build(BuildContext context) {
    // final users = Provider.of<List<UserModel>>(context);

    return Scaffold(
      body: StreamProvider.value(
        value: _userService.serchUsers(search),
        initialData: null,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextField(
                decoration: InputDecoration(hintText: 'Search'),
                onChanged: (val) {
                  setState(() {
                    search = val;
                  });
                },
              ),
            ),
            ListUsers(),
          ],
        ),
      ),
    );
  }
}
