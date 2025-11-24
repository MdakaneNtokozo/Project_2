import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/logged_in_member.dart';
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/helper%20models/tasks_for_the_week.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksMain extends StatefulWidget {
  const TasksMain({super.key});

  @override
  State<TasksMain> createState() => _TasksMainState();
}

class _TasksMainState extends State<TasksMain> {
  TasksForTheWeek weeklyTasks = TasksForTheWeek();
  List<CompletedTask> completedTasks = [];
  DateTime today = DateTime.now();
  late DateTime daySelected = DateTime(today.year, today.month, today.day);
  late DateTime dayFocused = DateTime(today.year, today.month, today.day);

  @override
  void initState() {
    super.initState();

    var result1 = ApiCalls().getWeeklyTasks(LoggedInMember().logginInMember!.familyGroupId);
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
        completedTask.dayNeededToBeCompleted
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
      var response = ApiCalls().deleteCompletedTask(completedTask);
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
      appBar: AppBar(title: Text("Tasks"), centerTitle: true,),
      drawer: LoggedInMember().logginInMember?.familyMemberRole == 1 ? TasksDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: dayFocused,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) {
                return isSameDay(daySelected, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  daySelected = selectedDay;
                  dayFocused = DateTime.parse(
                    focusedDay.toIso8601String().substring(
                      0,
                      focusedDay.toIso8601String().length - 1,
                    ),
                  );
                });
              },
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(),
            ),

            weeklyTasks.tasks != null && weeklyTasks.tasks!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: weeklyTasks.tasks!.length,
                    itemBuilder: (context, idx) {
                      var task = weeklyTasks.tasks!.elementAt(idx);

                      var selectedDays = weeklyTasks.selectedDays;
                      var sd = selectedDays!.firstWhere(
                        (s) => s.selectedDaysId == task.selectedDaysId,
                      );

                      CompletedTask completedTask = completedTasks.firstWhere(
                        (ct){ 
                          return ct.taskId == task.taskId && 
                          ct.dayNeededToBeCompleted == dayFocused;
                          },
                        orElse: () => CompletedTask(
                          taskId: -1,
                          familyMemberId: -1,
                          dayNeededToBeCompleted: dayFocused,
                          dayActuallyCompleted:DateTime(1, 1, 1)
                        ),
                      );

                      if (sd.monday == dayFocused ||
                          sd.tuesday == dayFocused ||
                          sd.wednesday == dayFocused ||
                          sd.thursday == dayFocused ||
                          sd.friday == dayFocused ||
                          sd.saturday == dayFocused ||
                          sd.sunday == dayFocused) {
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

                                    completedTask.familyMemberId == LoggedInMember().logginInMember?.familyMemberId?
                                    Checkbox(
                                      value: true, 
                                      onChanged: (newVal){
                                        handleCompletedTask(completedTask, task);
                                      }
                                      ): 
                                      completedTask.familyMemberId > -1?
                                      Icon(Icons.done_all_outlined): 
                                       Checkbox(
                                      value: false, 
                                      onChanged: (newVal){
                                        handleCompletedTask(completedTask, task);
                                      }
                                      )
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
