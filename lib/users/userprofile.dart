import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_app/models/user.dart';

class UserProfile extends StatelessWidget {
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("UserProfile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Center(
            child: Container(
              height: 110,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.memory(base64Decode(user.getUserImage()),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Center(
            child: Text(user.getUserName()),
          ),
          Center(child: Text("Email:" + user.getUserEmail())),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.blueGrey,
            height: 2,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
