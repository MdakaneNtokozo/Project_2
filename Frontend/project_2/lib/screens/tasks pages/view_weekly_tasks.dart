import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/models/reward.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/models/week.dart';

class ViewWeeklyTasks extends StatefulWidget {
  final List<Task> tasks;
  final Week week;
  final Reward reward;
  const ViewWeeklyTasks({
    super.key,
    required this.tasks,
    required this.week,
    required this.reward,
  });

  @override
  State<ViewWeeklyTasks> createState() => _ViewWeeklyTasksState();
}

class _ViewWeeklyTasksState extends State<ViewWeeklyTasks> {
  List<Widget> taskWidgets = [];

  @override
  void initState() {
    super.initState();
  }

  Widget getTaskWidget(Task task) {
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
                hintText: task.taskName,
              ),
            ),

            Text("Description"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintText: task.taskDesc,
              ),
            ),

            Text("Points"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintText: task.taskPoints.toString(),
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
                  "Week ${widget.week.weekNo}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                widget.tasks.isNotEmpty
                    ? SizedBox(
                        height: 560,
                        child: ListView.builder(
                          itemCount: widget.tasks.length,
                          itemBuilder: (context, idx) {
                            var task = widget.tasks.elementAt(idx);
                            return getTaskWidget(task);
                          },
                        ),
                      )
                    : Text("There are no task sections added"),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reward name"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: widget.reward.rewardName,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),

                    Text("Description"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: widget.reward.rewardDesc,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
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
