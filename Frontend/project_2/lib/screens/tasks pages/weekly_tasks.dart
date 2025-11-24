import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/logged_in_member.dart';
import 'package:project_2/models/selected_days.dart';
import 'package:project_2/models/task.dart';
import 'package:project_2/helper%20models/tasks_for_the_week.dart';

class WeeklyTasks extends StatefulWidget {
  const WeeklyTasks({super.key});

  get tasks => null;

  @override
  State<WeeklyTasks> createState() => _WeeklyTasksState();
}

class _WeeklyTasksState extends State<WeeklyTasks> {
  TasksForTheWeek weeklyTasks = TasksForTheWeek();

  @override
  void initState() {
    super.initState();
    var result = ApiCalls().getWeeklyTasks(LoggedInMember().logginInMember!.familyGroupId);
    result.then((wt) =>{
      setState(() {
        weeklyTasks = wt;
      })
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

  getTotalPoints(List<Task> tasks) {
    int total = 0;
    for(int i = 0; i < tasks.length; i++){
      total += tasks.elementAt(i).taskPoints;
    }

    return total;
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
                            
                            var totalPoints = getTotalPoints(tasks);

                            var allSelectedDays = weeklyTasks.selectedDays;
                            List<SelectedDays> selectedDays = [];
                            tasks.forEach((t){
                              var sd = allSelectedDays?.firstWhere((d) => d.selectedDaysId == t.selectedDaysId);
                              if(sd != null){
                                selectedDays.add(sd);
                              }
                            });

                            return GestureDetector(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Week ${week!.weekNo}"),
                                      Text("${tasks.length} tasks"),
                                      Text("$totalPoints total points"),
                                      Text("Reward: ${reward!.rewardName}"),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                //Navigate to the view weekly task
                                TasksForTheWeek wt = TasksForTheWeek();
                                wt.weeks = [week];
                                wt.tasks =  tasks;
                                wt.rewards = [reward];
                                wt.selectedDays = selectedDays; 

                                Navigator.pushNamed(context, "/viewWeeklyTasks", arguments: wt);
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
