import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/screens/tasks%20pages/view_weekly_tasks.dart';

class WeeklyTasks extends StatefulWidget {
  const WeeklyTasks({super.key});

  @override
  State<WeeklyTasks> createState() => _WeeklyTasksState();
}

class _WeeklyTasksState extends State<WeeklyTasks> {
  List tasks = ["task 1", "task 2"];

  void filterTasks() {
    showDialog(
      context: context, 
      builder:(context) {
        return Dialog(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            width: MediaQuery.widthOf(context) * 0.8,
            child: Card(
              
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks"), centerTitle: true),
      drawer: TasksDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: filterTasks,
              icon: Icon(Icons.filter_alt_outlined),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  tasks.isNotEmpty
                      ? ListView.builder(
                        shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (context, idx) {
                            return GestureDetector(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Week no."),
                                      Text("... tasks"),
                                      Text("... total points"),
                                      Text("Reward: ..."),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                //Navigate to the view weekly task
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder:(context) => ViewWeeklyTasks(tasks: tasks))
                                );
                              },
                            );
                          },
                        )
                      : Text("There are no weekly tasks"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
