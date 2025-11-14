import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/components/tasks_drawer.dart';

class AddTasks2 extends StatefulWidget {
  const AddTasks2({super.key});

  @override
  State<AddTasks2> createState() => _AddTasks2State();
}

class _AddTasks2State extends State<AddTasks2> {
  TextEditingController rewardName = TextEditingController();
  TextEditingController rewardDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                onPressed: (){
                  Navigator.pushNamed(context, "/tasksMain");
                }, 
                child: Text("Save tasks")
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
