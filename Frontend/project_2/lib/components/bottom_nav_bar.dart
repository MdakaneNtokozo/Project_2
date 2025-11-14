import 'package:flutter/material.dart';

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
  int currentNavItem = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navItems,
      currentIndex: currentNavItem,
      onTap: (value) {
        setState(() {
          currentNavItem = value;
          
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
          }
        });
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: const Color.fromARGB(255, 138, 202, 255),
    );
  }
}
