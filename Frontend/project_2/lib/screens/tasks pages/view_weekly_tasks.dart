import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';

class ViewWeeklyTasks extends StatefulWidget {
  final List tasks;
  const ViewWeeklyTasks({super.key, required this.tasks});

  @override
  State<ViewWeeklyTasks> createState() => _ViewWeeklyTasksState();
}

class _ViewWeeklyTasksState extends State<ViewWeeklyTasks> {
  List<Widget> taskWidgets = [];

  @override
  void initState() {
    super.initState();
  }

  Widget getTaskWidget(int idx) {
    return Card(
      child: Container(
        color: Colors.grey,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Task name"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
              ),
            ),

            Text("Description"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
              ),
            ),

            Text("Points"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selected the task's days"),

                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.multi,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now(),
                    firstDayOfWeek: 1,
                    hideLastMonthIcon: true,
                    hideNextMonthIcon: true,
                    disableModePicker: true,
                    disableMonthPicker: true,
                  ),
                  value: [],
                ),
              ],
            ),

            Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"), centerTitle: true),
      drawer: TasksDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Week ...",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                widget.tasks.isNotEmpty
                    ? SizedBox(
                        height: 560,
                        child: ListView.builder(
                          itemCount: widget.tasks.length,
                          itemBuilder: (context, idx) {
                            return getTaskWidget(idx);
                          },
                        ),
                      )
                    : Text("There are no task sections added"),
              ],
            ),

            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Icon(Icons.edit)),

                ElevatedButton(onPressed: () {}, child: Icon(Icons.delete)),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}
