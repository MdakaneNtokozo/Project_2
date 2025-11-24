import 'package:flutter/material.dart';
import 'package:project_2/logged_in_member.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_calendar_rounded),
      label: "Tasks",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: "Leaderboard"),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rewards"),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navItems,
      currentIndex: LoggedInMember().bottomNavIdx,
      onTap: (value) {
        setState(() {
          LoggedInMember().bottomNavIdx = value;
          
          switch (value) {
            case 0:
              {
                Navigator.pushNamed(context, "/home");
                break;
              }
            case 1:
              {
                Navigator.pushNamed(context, "/tasksMain");
                break;
              }
              case 2:
              {
                Navigator.pushNamed(context, "/leaderboard");
              }
              case 3:
              {
                Navigator.pushNamed(context, "/rewards");
              }
          }
        });
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: const Color.fromARGB(255, 138, 202, 255),
    );
  }
}
