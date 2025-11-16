import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/models/task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [];
  List<CompletedTask> completedTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.heightOf(context) * 0.2,
              color: Color.fromARGB(255, 57, 166, 255),
            ),

            Text(
              "Today's tasks",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            tasks.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, idx) {
                      Task task = tasks.elementAt(idx);
                      bool isTaskCompleted = completedTasks.any(
                        (ct) => ct.taskId == task.taskId,
                      );
                      var completedTask = completedTasks.firstWhere(
                        (ct) => ct.taskId == task.taskId,
                        orElse: () => CompletedTask(
                          taskId: -1,
                          familyMemberId: -1,
                          timeCompleted: DateTime.now(), //emty completed task variable
                        ),
                      );

                      return Card(
                        child: Container(
                          color: const Color.fromARGB(255, 238, 238, 238),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.taskName),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(task.taskDesc),
                                  Checkbox(
                                    value: isTaskCompleted == true
                                        ? true
                                        : false,
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Text("There are no tasks added for today"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
