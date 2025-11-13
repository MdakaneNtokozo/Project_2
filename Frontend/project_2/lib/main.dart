import 'package:flutter/material.dart';
import 'package:project_2/screens/home.dart';
import 'package:project_2/screens/login.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_group_id.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_invite.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_main.dart';
import 'package:project_2/screens/tasks%20pages/tasks_main.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
        "/signupmain": (context) => SignupMain(),
        "/signupInvite": (context) => SignupInvite(),
        "/signupGroupId": (context) => SignupGroupId(),
        "/home": (context) => Home(),
        "/tasksMain": (context) => TasksMain()
      },
      debugShowCheckedModeBanner: false,
    )
  );
}