import 'package:flutter/material.dart';
import 'package:project_2/screens/home.dart';
import 'package:project_2/screens/leaderboard/leaderboard.dart';
import 'package:project_2/screens/leaderboard/view_leaderboard_entry.dart';
import 'package:project_2/screens/login.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_group_id.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_invite.dart';
import 'package:project_2/screens/sign%20up%20pages/signup_main.dart';
import 'package:project_2/screens/tasks%20pages/add_tasks_1.dart';
import 'package:project_2/screens/tasks%20pages/add_tasks_2.dart';
import 'package:project_2/screens/tasks%20pages/tasks_main.dart';
import 'package:project_2/screens/tasks%20pages/view_weekly_tasks.dart';
import 'package:project_2/screens/tasks%20pages/weekly_tasks.dart';

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
        "/tasksMain": (context) => TasksMain(),
        "/addTasks1": (context) => AddTasks1(),
        "/addTasks2": (context) => AddTasks2(),
        "/weeklyTasks": (context) => WeeklyTasks(),
        "/viewWeeklyTasks": (context) => ViewWeeklyTasks(),
        "/leaderboard": (context) => Leaderboard(),
        "/viewLeaderboardEntry": (context) => ViewLeaderboardEntry()
      },
      debugShowCheckedModeBanner: false,
    )
  );
}