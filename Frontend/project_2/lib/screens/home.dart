import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/tasks_for_the_week.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TasksForTheWeek weeklyTasks = TasksForTheWeek();
  List<CompletedTask> completedTasks = [];
  DateTime now = DateTime.now();
  late DateTime today = DateTime(now.year, now.month, now.day);

  @override
  void initState() {
    super.initState();

    var result = ApiCalls().getWeeklyTasks();
    result.then((wt) {
      setState(() {
        weeklyTasks = wt;
      });
    });
  }

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

            weeklyTasks.tasks != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: weeklyTasks.tasks!.length,
                    itemBuilder: (context, idx) {
                      Task task = weeklyTasks.tasks!.elementAt(idx);

                      var selectedDays = weeklyTasks.selectedDays;
                      var sd = selectedDays!.firstWhere(
                        (s) => s.selectedDaysId == task.selectedDaysId,
                      );

                      bool isTaskCompleted = completedTasks.any(
                        (ct) => ct.taskId == task.taskId,
                      );
                      var completedTask = completedTasks.firstWhere(
                        (ct) => ct.taskId == task.taskId,
                        orElse: () => CompletedTask(
                          taskId: -1,
                          familyMemberId: -1,
                          timeCompleted:
                              DateTime.now(), //emty completed task variable
                        ),
                      );

                      if (sd.monday == today ||
                          sd.tuesday == today ||
                          sd.wednesday == today ||
                          sd.thursday == today ||
                          sd.friday == today ||
                          sd.saturday == today ||
                          sd.sunday == today) {
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
                      } else {
                        return Text("There are no tasks added for today");
                      }
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
