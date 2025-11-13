import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';

class TasksMain extends StatefulWidget {
  const TasksMain({super.key});

  @override
  State<TasksMain> createState() => _TasksMainState();
}

class _TasksMainState extends State<TasksMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"), 
        centerTitle: true,
        automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
              height: MediaQuery.heightOf(context) * 0.2,
              color: Color.fromARGB(255, 57, 166, 255),
            ),
      
            
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar()
      
    );
  }
}