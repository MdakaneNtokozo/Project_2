import 'package:flutter/material.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/models/leaderboard_class.dart';

class ViewLeaderboardEntry extends StatefulWidget {
  const ViewLeaderboardEntry({super.key});

  @override
  State<ViewLeaderboardEntry> createState() => _ViewLeaderboardEntryState();
}

class _ViewLeaderboardEntryState extends State<ViewLeaderboardEntry> {
  @override
  Widget build(BuildContext context) {
    var entry = ModalRoute.of(context)?.settings.arguments as LeaderboardClass;

    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard entry"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
              "${entry.member.familyMemberName} ${entry.member.familyMemberSurname}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            Text(
              "${entry.totalPoints} points",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: entry.tasksCompleted.length,
              itemBuilder: (context, idx) {
                var task = entry.tasksCompleted[idx];

                return Card(
                  child: Container(
                    color: const Color.fromARGB(255, 238, 238, 238),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.taskName),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(task.taskDesc)],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
