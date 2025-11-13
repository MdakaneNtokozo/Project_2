import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tasks = ["task 1", "task 2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"), 
        centerTitle: true,
        automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Container(
              height: MediaQuery.heightOf(context) * 0.2,
              color: Color.fromARGB(255, 57, 166, 255),
            ),
      
            Text(
              "Today's tasks",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
      
            tasks.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, idx) {
                      return Container(
                        color: const Color.fromARGB(255, 238, 238, 238),
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
                                    print(value);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Text("There are no tasks added for today"),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar()
      
    );
  }
}
