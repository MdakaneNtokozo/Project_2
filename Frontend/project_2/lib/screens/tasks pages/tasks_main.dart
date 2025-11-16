import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/models/task.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksMain extends StatefulWidget {
  const TasksMain({super.key});

  @override
  State<TasksMain> createState() => _TasksMainState();
}

class _TasksMainState extends State<TasksMain> {
  List<Task> tasks = [];
  List<CompletedTask> completedTasks = [];
  DateTime selectedDay = DateTime.now();
  DateTime selectedFocusedDay = DateTime.now();

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
              focusedDay: selectedFocusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDay = selectedDay;
                  selectedFocusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                
              ),
            ),

            tasks.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, idx) {
                      var task = tasks.elementAt(idx);
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(task.taskDesc),
                                  Checkbox(
                                    value: isTaskCompleted == true ? true: false,
                                    onChanged: (value) {
                                    },
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
