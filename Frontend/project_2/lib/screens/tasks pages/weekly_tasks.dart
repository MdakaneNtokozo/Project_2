import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/screens/tasks%20pages/view_weekly_tasks.dart';
import 'package:project_2/tasks_for_the_week.dart';

class WeeklyTasks extends StatefulWidget {
  const WeeklyTasks({super.key});

  get tasks => null;

  @override
  State<WeeklyTasks> createState() => _WeeklyTasksState();
}

class _WeeklyTasksState extends State<WeeklyTasks> {
  late TasksForTheWeek weeklyTasks;

  @override
  void initState() {
    super.initState();
    var result = ApiCalls().getWeeklyTasks();
    result.then((wt) =>{
      weeklyTasks = wt
    });
  }

  void filterTasks() {
    showDialog(
      context: context, 
      builder:(context) {
        return Dialog(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            width: MediaQuery.widthOf(context) * 0.8,
            child: Card(
              
            ),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks"), centerTitle: true),
      drawer: TasksDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: filterTasks,
              icon: Icon(Icons.filter_alt_outlined),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  weeklyTasks.weeks != null
                      ? ListView.builder(
                        shrinkWrap: true,
                          itemCount: weeklyTasks.weeks?.length,
                          itemBuilder: (context, idx) {
                            var week = weeklyTasks.weeks?.elementAt(idx);
                            var tasks = weeklyTasks.tasks;
                            tasks!.retainWhere((task) => task.weekId == week!.weekId);
                            var reward = weeklyTasks.rewards?.firstWhere((r) => r.rewardId == week!.rewardId);
                            
                            return GestureDetector(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Week ${week!.weekNo}"),
                                      Text("${tasks.length} tasks"),
                                      Text("... total points"),
                                      Text("Reward: ${reward!.rewardName}"),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                //Navigate to the view weekly task
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder:(context) => ViewWeeklyTasks(week: week, tasks: tasks, reward: reward))
                                );
                              },
                            );
                          },
                        )
                      : Text("There are no weekly tasks"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
