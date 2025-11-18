import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/tasks_for_the_week.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class AddTasks1 extends StatefulWidget {
  const AddTasks1({super.key});

  @override
  State<AddTasks1> createState() => _AddTasks1State();
}

class _AddTasks1State extends State<AddTasks1> {
  DateTime selectedDay = DateTime.now();
  DateTime monday = DateTime.now();
  DateTime sunday = DateTime.now();

  List<Widget> taskWidgets = [];
  int count = 0;
  List<TextEditingController> taskNameControllers = [];
  List<TextEditingController> taskDescControllers = [];
  List<TextEditingController> taskPointsControllers = [];
  List<List<DateTime>> taskDaysSelected = [];
  List<int> idxRemoved = [];

  void getDates() {
    //Getting the first date of the week
    if (selectedDay.weekday != 1) {
      int subtractDays = selectedDay.weekday - 1;
      setState(() {
        monday = selectedDay.subtract(Duration(days: subtractDays));
      });
    }

    //Getting the last date of the week
    if (selectedDay.weekday != 7) {
      int subtractDays = 7 - selectedDay.weekday;
      setState(() {
        sunday = selectedDay.add(Duration(days: subtractDays));
      });
    }
  }

  void addTaskWidget() {
    setState(() {
      taskNameControllers.add(TextEditingController());
      taskDescControllers.add(TextEditingController());
      taskPointsControllers.add(TextEditingController());
      taskDaysSelected.add([]);
      int index = count;

      taskWidgets.add(
        Card(
          child: Container(
            color: Colors.grey,
            height: 650,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task name"),
                TextField(
                  controller: taskNameControllers[index],
                  decoration: InputDecoration(
                    hintText: "Enter the name of the task",
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),

                Text("Description"),
                TextField(
                  controller: taskDescControllers[index],
                  decoration: InputDecoration(
                    hintText: "Enter the task's description",
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),

                Text("Points"),
                TextField(
                  controller: taskPointsControllers[index],
                  decoration: InputDecoration(
                    hintText: "Enter the task's points",
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select the task's days"),

                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.multi,
                        firstDate: monday,
                        lastDate: sunday,
                        firstDayOfWeek: 1,
                        hideLastMonthIcon: true,
                        hideNextMonthIcon: true,
                        disableModePicker: true,
                        disableMonthPicker: true,
                      ),
                      value: taskDaysSelected[index],
                      onValueChanged: (value) {
                        taskDaysSelected[index] = value;
                      },
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    removeTaskWidget(index);
                  },
                  child: Text("Remove"),
                ),

                Divider(),
              ],
            ),
          ),
        ),
      );

      count++;
    });
  }

  void removeTaskWidget(int idx) {
    setState(() {
      taskWidgets.removeAt(idx);
      idxRemoved.add(idx);
    });
  }

  @override
  void initState() {
    super.initState();
    getDates();
  }

  void createWeeklyTasks() {
    if (taskNameControllers.length == taskDescControllers.length &&
        taskDescControllers.length == taskPointsControllers.length &&
        taskPointsControllers.length == taskDaysSelected.length &&
        taskNameControllers.isNotEmpty) {
      List<Task> tasks = [];
      for (int i = 0; i < taskNameControllers.length; i++) {
        if (!idxRemoved.contains(i)) {
          var taskName = taskNameControllers.elementAt(i).text;
          var taskDesc = taskDescControllers.elementAt(i).text;
          var taskPoints = taskPointsControllers.elementAt(i).text;

          var newTask = Task(
            taskId: -1,
            taskName: taskName,
            taskDesc: taskDesc,
            taskPoints: int.parse(taskPoints),
            weekId: -1,
            selectedDaysId: -1,
          );

          tasks.add(newTask);
        }
      }

      List<List<DateTime>> dates = [];
      for(int i = 0; i < taskDaysSelected.length; i++){
        if(!idxRemoved.contains(i)){
          dates.add(taskDaysSelected.elementAt(i));
        }
      }

      TasksForTheWeek tasksForTheWeek = TasksForTheWeek(
        weeks: null,
        tasks: tasks,
        dates: dates,
        selectedDays: null,
        rewards: null,
        monday: monday,
        sunday: sunday,
      );

      Navigator.pushNamed(context, "/addTasks2", arguments: tasksForTheWeek);
    }
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
          children: [
            Text("Choose a week"),
            WeeklyDatePicker(
              selectedDay: selectedDay,
              changeDay: (newDay) {
                setState(() {
                  selectedDay = newDay;
                });
                getDates();
              },
              enableWeeknumberText: true,
            ),

            Divider(),

            taskWidgets.isNotEmpty
                ? SizedBox(
                    height: 460,
                    child: ListView.builder(
                      itemCount: taskWidgets.length,
                      itemBuilder: (context, idx) {
                        return taskWidgets[idx];
                      },
                    ),
                  )
                : Text("There are no task sections added"),

            Padding(
              padding: const EdgeInsets.fromLTRB(160, 0, 0, 0),
              child: ElevatedButton(
                onPressed: addTaskWidget,
                child: Icon(Icons.add_circle_outline_rounded),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(160, 0, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  createWeeklyTasks();
                },
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}
