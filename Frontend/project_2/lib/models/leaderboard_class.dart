import 'dart:convert';
import 'package:project_2/models/family_member.dart';
import 'package:project_2/models/task.dart';

LeaderboardClass rewardFromJson(String str) => LeaderboardClass.fromJson(json.decode(str));

String rewardToJson(LeaderboardClass data) => json.encode(data.toJson());

class LeaderboardClass {
  FamilyMember member;
  List<Task> tasksCompleted;
  int totalPoints;

  LeaderboardClass({
    required this.member,
    required this.tasksCompleted,
    required this.totalPoints,
  });

  factory LeaderboardClass.fromJson(Map<String, dynamic> json) =>
      LeaderboardClass(
        member: FamilyMember.fromJson(json["member"]),
        tasksCompleted: List<Task>.from(
          json["tasksCompleted"].map((x) => Task.fromJson(x)),
        ),
        totalPoints: json["totalPoints"],
      );

  Map<String, dynamic> toJson() => {
    "member": member,
    "tasksCompleted": tasksCompleted,
    "totalPoints": totalPoints,
  };
}
