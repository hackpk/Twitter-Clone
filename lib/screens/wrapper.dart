import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/user_model.dart';
import 'package:twitter/screens/auth/sign_up.dart';
import 'package:twitter/screens/main/home.dart';
import 'package:twitter/screens/main/posts/add.dart';
import 'package:twitter/screens/main/profile/edit.dart';
import 'package:twitter/screens/main/profile/profile.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    print(user);
    if (user == null) {
      return SignUp();
    }
    return MaterialApp(
      routes: {
        '/': (context) => Home(),
        '/add': (context) => Add(),
        '/profile': (context) => Profile(),
        '/edit': (context) => Edit(),
      },
    );
  }
}
