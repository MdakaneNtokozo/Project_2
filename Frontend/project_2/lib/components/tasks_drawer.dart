import 'package:flutter/material.dart';

class TasksDrawer extends StatefulWidget {
  const TasksDrawer({super.key});

  @override
  State<TasksDrawer> createState() => _TasksDrawerState();
}

class _TasksDrawerState extends State<TasksDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Tasks")
            ),
            ListTile(
              title: Text("View Tasks"),
              onTap: () {
                Navigator.pushNamed(context, "/tasksMain");
              },
            ),
            ListTile(
              title: Text("Add tasks"),
              onTap: () {
                Navigator.pushNamed(context, "/addTasks1");
              },
            ),
            ListTile(
              title: Text("Weekly tasks"),
              onTap: () {
                Navigator.pushNamed(context, "/weeklyTasks");
              },
            ),
          ],
        ),
      );
  }
}