import 'package:flutter/material.dart';
import 'package:project_2/screens/login.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Login()
      },
      debugShowCheckedModeBanner: false,
    )
  );
}