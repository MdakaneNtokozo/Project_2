import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/logged_in_member.dart';
import 'package:project_2/models/selected_days.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/models/week.dart';
import 'package:project_2/tasks_for_the_week.dart';

class ViewWeeklyTasks extends StatefulWidget {
  const ViewWeeklyTasks({super.key});

  @override
  State<ViewWeeklyTasks> createState() => _ViewWeeklyTasksState();
}

class _ViewWeeklyTasksState extends State<ViewWeeklyTasks> {
  List<List<DateTime>> dates = [];
  bool enableEdit = false;
  List<Widget> taskWidgets = [];
  int count = 0;
  List<TextEditingController> taskNameControllers = [];
  List<TextEditingController> taskDescControllers = [];
  List<TextEditingController> taskPointsControllers = [];
  List<List<DateTime>> taskDaysSelected = [];
  List<int> idxRemoved = [];

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> convertToDateList(SelectedDays sd) {
    List<DateTime> dates = [];

    if (sd.monday != null) {
      dates.add(sd.monday!);
    }

    if (sd.tuesday != null) {
      dates.add(sd.tuesday!);
    }

    if (sd.wednesday != null) {
      dates.add(sd.wednesday!);
    }

    if (sd.thursday != null) {
      dates.add(sd.thursday!);
    }

    if (sd.friday != null) {
      dates.add(sd.friday!);
    }

    if (sd.saturday != null) {
      dates.add(sd.saturday!);
    }

    if (sd.sunday != null) {
      dates.add(sd.sunday!);
    }

    return dates;
  }

  Widget getTaskWidget(
    Task task,
    SelectedDays selectedDays,
    Week week,
    int idx, 
    TasksForTheWeek weeklyTasks,
  ) {
    return Card(
      child: Container(
        color: Colors.grey,
        height: 650,
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
              readOnly: !enableEdit,
              onChanged: (newTaskName) {
                task.taskName = newTaskName;
              },
            ),

            Text("Description"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintText: task.taskDesc,
              ),
              readOnly: !enableEdit,
              onChanged: (newTaskDesc) {
                task.taskDesc = newTaskDesc;
              },
            ),

            Text("Points"),
            TextField(
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintText: task.taskPoints.toString(),
              ),
              readOnly: !enableEdit,
              onChanged: (newPoints) {
                task.taskPoints = int.parse(newPoints);
              },
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selected the task's days"),

                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.multi,
                    firstDate: week.monday,
                    lastDate: week.sunday,
                    firstDayOfWeek: 1,
                    hideLastMonthIcon: true,
                    hideNextMonthIcon: true,
                    disableModePicker: true,
                    disableMonthPicker: true,
                  ),
                  value: convertToDateList(selectedDays),
                  onValueChanged: (value) {
                    selectedDays.monday = null;
                    selectedDays.tuesday = null;
                    selectedDays.wednesday = null;
                    selectedDays.thursday = null;
                    selectedDays.friday = null;
                    selectedDays.saturday = null;
                    selectedDays.sunday = null;

                    for (int i = 0; i < value.length; i++) {
                      var newDate = value.elementAt(i);

                      if (newDate.weekday == DateTime.monday) {
                        selectedDays.monday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.tuesday) {
                        selectedDays.tuesday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.wednesday) {
                        selectedDays.wednesday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.thursday) {
                        selectedDays.thursday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.friday) {
                        selectedDays.friday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.saturday) {
                        selectedDays.saturday = value.elementAt(i);
                      } else if (newDate.weekday == DateTime.sunday) {
                        selectedDays.sunday = value.elementAt(i);
                      }
                    }
                  },
                ),
              ],
            ),

            enableEdit == true ?
            ElevatedButton(
                  onPressed: () {
                    setState(() {
                      weeklyTasks.tasks?.remove(task);
                    });
                  },
                  child: Text("Remove"),
                ): Container(),

            Divider(),
          ],
        ),
      ),
    );
  }

  void addTaskWidget(TasksForTheWeek weeklyTasks) {
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
                        firstDate: weeklyTasks.monday,
                        lastDate: weeklyTasks.sunday,
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

  void saveEdits(TasksForTheWeek wt) {
    if (taskNameControllers.length == taskDescControllers.length &&
        taskDescControllers.length == taskPointsControllers.length &&
        taskPointsControllers.length == taskDaysSelected.length) {
      List<Task> tasks = [];
      for (int i = 0; i < taskNameControllers.length; i++) {
        var taskName = taskNameControllers.elementAt(i).text;
        var taskDesc = taskDescControllers.elementAt(i).text;
        var taskPoints = taskPointsControllers.elementAt(i).text;
        if (!idxRemoved.contains(i)) {
          var newTask = Task(
            taskId: -1,
            taskName: taskName,
            taskDesc: taskDesc,
            taskPoints: int.parse(taskPoints),
            weekId: -1,
            selectedDaysId: -1,
            familyGroupId: LoggedInMember().logginInMember!.familyGroupId
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

      wt.tasks?.addAll(tasks);
      wt.dates = dates;

      var response = ApiCalls().updateWeeklyTasks(wt);
      response.then((updated) {
        if (updated == true) {
          Navigator.pushNamed(context, "/weeklyTasks");
        }
      });
    }
  }

  void deleteWeeklyTasks(Week week) {
    var response = ApiCalls().deleteWeeklyTasks(week);
    response.then((updated) {
      if (updated == true) {
        Navigator.pushNamed(context, "/weeklyTasks");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TasksForTheWeek weeklyTasks =
        ModalRoute.of(context)?.settings.arguments as TasksForTheWeek;

    return Scaffold(
      appBar: AppBar(title: Text("Add Task"), centerTitle: true),
      drawer: TasksDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Week ${weeklyTasks.weeks!.elementAt(0).weekNo}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  weeklyTasks.tasks != null && weeklyTasks.tasks!.isNotEmpty
                      ? SizedBox(
                          height: 560,
                          child: ListView.builder(
                            itemCount: weeklyTasks.tasks!.length,
                            itemBuilder: (context, idx) {
                              var task = weeklyTasks.tasks!.elementAt(idx);
                              var selectedDays = weeklyTasks.selectedDays;
                              var sd = selectedDays!.firstWhere(
                                (sd) =>
                                    sd.selectedDaysId == task.selectedDaysId,
                              );

                              return getTaskWidget(
                                task,
                                sd,
                                weeklyTasks.weeks!.elementAt(0),
                                idx,
                                weeklyTasks
                              );
                            },
                          ),
                        )
                      : Text("There are no task sections added"),

                  taskWidgets.isNotEmpty
                      ? Column(
                          children: [
                            Text("New tasks being added"),
                            SizedBox(
                              height: 460,
                              child: ListView.builder(
                                itemCount: taskWidgets.length,
                                itemBuilder: (context, idx) {
                                  return taskWidgets[idx];
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),

                  enableEdit == true
                      ? ElevatedButton(
                          onPressed: () {
                            addTaskWidget(weeklyTasks);
                          },
                          child: Icon(Icons.add_circle_outline_rounded),
                        )
                      : Container(),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Reward name"),
                      TextField(
                        decoration: InputDecoration(
                          hintText: weeklyTasks.rewards!
                              .elementAt(0)
                              .rewardName,
                          filled: true,
                          border: InputBorder.none,
                        ),
                        readOnly: !enableEdit,
                        onChanged: (newRewardName) {
                          weeklyTasks.rewards!.elementAt(0).rewardName =
                              newRewardName;
                        },
                      ),

                      Text("Description"),
                      TextField(
                        decoration: InputDecoration(
                          hintText: weeklyTasks.rewards!
                              .elementAt(0)
                              .rewardDesc,
                          filled: true,
                          border: InputBorder.none,
                        ),
                        readOnly: !enableEdit,
                        onChanged: (newRewardDesc) {
                          weeklyTasks.rewards!.elementAt(0).rewardDesc =
                              newRewardDesc;
                        },
                      ),
                    ],
                  ),
                ],
              ),

              enableEdit == false
                  ? Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              enableEdit = true;
                            });
                          },
                          child: Icon(Icons.edit),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            deleteWeeklyTasks(weeklyTasks.weeks!.elementAt(0));
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              enableEdit = false;
                            });
                          },
                          child: Text("Cancel"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            saveEdits(weeklyTasks);
                          },
                          child: Text("Save edit"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}
