import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/tasks_for_the_week.dart';
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
      appBar: AppBar(title: Text("Tasks"), centerTitle: true),
      drawer: TasksDrawer(),
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
                  dayFocused = DateTime.parse(focusedDay.toIso8601String().substring(0, focusedDay.toIso8601String().length - 1));
                });
              },
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(),
            ),

            weeklyTasks.tasks != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: weeklyTasks.tasks!.length,
                    itemBuilder: (context, idx) {
                      var task = weeklyTasks.tasks!.elementAt(idx);

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
                      }else{
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
