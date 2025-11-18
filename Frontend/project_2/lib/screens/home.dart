import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/logged_in_member.dart';
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

    var result1 = ApiCalls().getWeeklyTasks();
    result1.then((wt) {
      setState(() {
        weeklyTasks = wt;
      });
    });

    
    var result2 = ApiCalls().getCompletedTasks();
    result2.then((ct) {
      setState(() {
        completedTasks = ct;
      });
    });
  }

  
  void handleCompletedTask(CompletedTask completedTask, Task task) {
    if (completedTask.taskId == -1) {
      var response = ApiCalls().addCompletedTask(
        LoggedInMember().logginInMember!.familyMemberId,
        task.taskId,
      );
      response.then((isAdded) {
        if (isAdded == true) {
          var result = ApiCalls().getCompletedTasks();
          result.then((ct) {
            setState(() {
              completedTasks = ct;
            });
          });
        }
      });
    } else {
      var response = ApiCalls().deleteCompletedTask(
        LoggedInMember().logginInMember!.familyMemberId,
        task.taskId,
      );
      response.then((isDeleted) {
        if (isDeleted == true) {
          var result = ApiCalls().getCompletedTasks();
          result.then((ct) {
            setState(() {
              completedTasks = ct;
            });
          });
        }
      });
    }
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

            Text("Welcome ${LoggedInMember().logginInMember?.familyMemberName}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            Text(
              "Today's tasks",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            weeklyTasks.tasks != null && weeklyTasks.tasks!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: weeklyTasks.tasks!.length,
                    itemBuilder: (context, idx) {
                      Task task = weeklyTasks.tasks!.elementAt(idx);

                      var selectedDays = weeklyTasks.selectedDays;
                      var sd = selectedDays!.firstWhere(
                        (s) => s.selectedDaysId == task.selectedDaysId,
                      );

                      CompletedTask completedTask = completedTasks.firstWhere(
                        (ct) => ct.taskId == task.taskId,
                        orElse: () => CompletedTask(
                          taskId: -1,
                          familyMemberId: -1,
                          timeCompleted:
                              DateTime.now(), //empty completed task variable
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

                                    completedTask.familyMemberId == -1 ||
                                    completedTask.familyMemberId == LoggedInMember().logginInMember?.familyMemberId ?
                                    Checkbox(
                                      value: completedTask.taskId != -1
                                          ? true
                                          : false,
                                      onChanged: (value) {
                                        handleCompletedTask(completedTask, task);
                                      },
                                    ): Icon(Icons.done_all)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text("");
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
