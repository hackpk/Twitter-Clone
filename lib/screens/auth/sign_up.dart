import 'package:flutter/material.dart';
import 'package:twitter/services/auth.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text('Sign Up'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 28, horizontal: 28),
          child: new Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                TextFormField(
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                TextButton(
                    onPressed: () async =>
                        {_authService.signUp(email, password)},
                    child: Text('Sign Up')),
                TextButton(
                    onPressed: () async =>
                        {_authService.signIn(email, password)},
                    child: Text('Sign In'))
              ],
            ),
          )),
    );
  }
}
