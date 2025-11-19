import 'dart:convert';
import 'package:project_2/models/family_member.dart';

LeaderboardClass rewardFromJson(String str) => LeaderboardClass.fromJson(json.decode(str));

String rewardToJson(LeaderboardClass data) => json.encode(data.toJson());

class LeaderboardClass {
    FamilyMember member;
    int numTasksCompleted;
    int totalPoints;

    LeaderboardClass({
      required this.member,
      required this.numTasksCompleted,
      required this.totalPoints
    });

    factory LeaderboardClass.fromJson(Map<String, dynamic> json) => LeaderboardClass(
        member: FamilyMember.fromJson(json["member"]),
        numTasksCompleted: json["numTasksCompleted"],
        totalPoints: json["totalPoints"],
    );

    Map<String, dynamic> toJson() => {
        "member": member,
        "numTasksCompleted": numTasksCompleted,
        "totalPoints": totalPoints,
    };
}
