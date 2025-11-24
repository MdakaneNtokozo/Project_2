import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/components/bottom_nav_bar.dart';
import 'package:project_2/helper%20models/tasks_for_the_week.dart';
import 'package:project_2/logged_in_member.dart';
import 'package:project_2/models/family_member.dart';

class Rewards extends StatefulWidget {
  const Rewards
({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  //have a class that has a week, reward and reward won
  late TasksForTheWeek weeksInfo;
  late List<FamilyMember> members;
  bool infoRetrieved = false;

  @override
  void initState() {
    super.initState();

    var response1 = ApiCalls().getFamilyMembers();
    response1.then((memebersRetrieved){
      setState(() {
        members = memebersRetrieved;
      });
    });

    var response2 = ApiCalls().getWeeksInfo(LoggedInMember().logginInMember!.familyGroupId);
    response2.then((weeksInfoRetrieved){
      setState(() {
        weeksInfo = weeksInfoRetrieved;
        infoRetrieved = true;
      });
    });
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

            infoRetrieved == true
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount:  weeksInfo.weeks!.length,
                    itemBuilder: (context, idx) {
                      var week =  weeksInfo.weeks![idx];
                      var reward = weeksInfo.rewards![idx];
                      var rewardWon = weeksInfo.rewardsWon![idx];

                      var tempMember = FamilyMember(familyMemberId: -1, familyMemberName: "", familyMemberSurname: "", familyMemberEmail: "", familyMemberPassword: "", familyMemberRole: -1, familyGroupId: "");
                      var member = members.firstWhere((m) => m.familyMemberId == rewardWon.familyMemberId, 
                      orElse: () => tempMember );

                      return  Card(
                          child: Container(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              height: 100,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.widthOf(context) * 0.15,
                                    child: Center(child: Text("${idx + 1}"))
                                    ),
                        
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Week no. ${week.weekNo}"),
                                      Text("Reward: ${reward.rewardName}"),
                                      
                                      rewardWon.rewardId == -1 && rewardWon.familyMemberId == -1 ?
                                      Text("Ongoing"):
                                      Text("Winner: ${member.familyMemberName} ${member.familyMemberSurname}")
                                    ],
                                  ),
                                ],
                              )
                          )
                        );
                          
                    },
                  )
                : Text("No weeks have been concluded."),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}