import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';
import 'package:project_2/models/reward.dart';
import 'package:project_2/helper%20models/tasks_for_the_week.dart';

class AddTasks2 extends StatefulWidget {
  const AddTasks2({super.key});

  @override
  State<AddTasks2> createState() => _AddTasks2State();
}

class _AddTasks2State extends State<AddTasks2> {
  TextEditingController rewardName = TextEditingController();
  TextEditingController rewardDesc = TextEditingController();

  void createWeeklyTasks(TasksForTheWeek tasksForTheWeek) {
    if (rewardName.text != "" && rewardDesc.text != "") {
      Reward reward = Reward(
        rewardId: -1,
        rewardName: rewardName.text,
        rewardDesc: rewardDesc.text,
        rewardImg: "",
      );

      tasksForTheWeek.rewards = [reward];

      var result = ApiCalls().createWeeklyTasks(tasksForTheWeek);
      result.then(
        (complete) => {
          if (complete == true) {
            Navigator.pushNamed(context, "/tasksMain")
          },
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TasksForTheWeek tasksForTheWeek =
        ModalRoute.of(context)!.settings.arguments as TasksForTheWeek;

    return Scaffold(
      appBar: AppBar(title: Text("Add tasks (cont)"), centerTitle: true),
      drawer: TasksDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reward name"),
                    TextField(
                      controller: rewardName,
                      decoration: InputDecoration(
                        hintText: "Enter the name of the reward",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description"),
                    TextField(
                      controller: rewardDesc,
                      decoration: InputDecoration(
                        hintText: "Enter the rewards's description",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(160, 0, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  createWeeklyTasks(tasksForTheWeek);
                },
                child: Text("Save tasks"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
