import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/logged_in_member.dart';
import 'package:project_2/models/leaderboard_class.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LeaderboardClass> entries = [];

  @override
  void initState() {
    super.initState();

    var response = ApiCalls().getLeaderboardEntries(
      LoggedInMember().logginInMember?.familyGroupId,
    );
    response.then((entriesRetrived) {
      setState(() {
        entries = entriesRetrived;
      });
    });
  }

  void rewardWinner(int memberId) {
    var response = ApiCalls().rewardTheWinner(memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
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

            entries.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (context, idx) {
                      var entry = entries[idx];

                      return GestureDetector(
                        child: Card(
                          child: Container(
                            color: const Color.fromARGB(255, 238, 238, 238),
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.widthOf(context) * 0.15,
                                  child: Center(child: Text("${idx + 1}")),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${entry.member.familyMemberName} ${entry.member.familyMemberSurname}",
                                    ),
                                    Text(
                                      "Tasks completed: ${entry.tasksCompleted.length}",
                                    ),
                                    Text("Total points: ${entry.totalPoints}"),
                                  ],
                                ),

                                idx + 1 == 1
                                    ? SizedBox(
                                        width:
                                            MediaQuery.widthOf(context) * 0.2,
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.widthOf(context) * 0.2,
                                        child: Text(""),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/viewLeaderboardEntry",
                            arguments: entry,
                          );
                        },
                      );
                    },
                  )
                : Text("No one has completed their tasks yet"),

            LoggedInMember().logginInMember?.familyMemberRole == 1
                ? ElevatedButton(
                    onPressed: () =>
                        rewardWinner(entries[0].member.familyMemberId),
                    child: Text("Reward the winner"),
                  )
                : Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
