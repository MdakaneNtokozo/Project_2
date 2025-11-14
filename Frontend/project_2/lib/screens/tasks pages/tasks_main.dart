import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class TasksMain extends StatefulWidget {
  const TasksMain({super.key});

  @override
  State<TasksMain> createState() => _TasksMainState();
}

class _TasksMainState extends State<TasksMain> {
  List tasks = ["task 1", "task 2"];
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
                      return Card(
                        child: Container(
                          color: const Color.fromARGB(255, 238, 238, 238),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tasks[idx]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("task description will be placed here"),
                                  Checkbox(
                                    value: false,
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
