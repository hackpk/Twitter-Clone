import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/user_model.dart';

class ListUsers extends StatefulWidget {
  ListUsers({Key key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  // UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserModel>>(context) ?? [];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/profile', arguments: user.id);
            },
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        user.profileImageUrl != ''
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    NetworkImage(user.profileImageUrl),
                              )
                            : Icon(
                                Icons.person,
                                size: 20,
                              ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          user.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                const Divider(thickness: 1),
              ],
            ));
      },
    );
  }
}
