import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_2/models/family_member.dart';
import 'package:project_2/tasks_for_the_week.dart';

class ApiCalls {
  //var api = "http://localhost:5063/api";
  var api = "http://10.220.36.84:45458/api";

  Future<bool> login(String email, String password) async {
    Uri uri = Uri.parse(
      "$api/FamilyMembers/login?email=$email&password=$password",
    );
    var response = await http.get(uri);
    var loginSuccessful = false;

    if (response.statusCode == 200) {
      loginSuccessful = true;
    }

    return loginSuccessful;
  }

  Future<String> signUpAsFamilyAdmin(FamilyMember member) async {
    Uri uri = Uri.parse("$api/FamilyMembers/signUpAsFamilyAdmin");
    var response = await http.post(
      uri,
      body: familyMemberToJson(member),
      headers: {"Content-type": "application/json"},
    );
    var groupId = "";

    if (response.statusCode == 200) {
      groupId = response.body;
    }

    return groupId;
  }

  Future<bool> signUpInFamilyGroup(
    FamilyMember member,
    String groupId,
    String tempPassword,
  ) async {
    Uri uri = Uri.parse(
      "$api/FamilyMembers/signUpInFamilyGroup?groupId=$groupId&tempPassword=$tempPassword",
    );
    var response = await http.post(
      uri,
      body: familyMemberToJson(member),
      headers: {"Content-type": "application/json"},
    );
    var signUpSuccessful = false;

    if (response.statusCode == 200) {
      signUpSuccessful = true;
    }

    return signUpSuccessful;
  }

  Future<bool> inviteUsers(
    List<TextEditingController> emails,
    List<String?> permissions,
    String groupId,
  ) async {
    var complete = false;

    if (emails.length == permissions.length) {
      for (int i = 0; i < emails.length; i++) {
        var email = emails.elementAt(i);
        var permission = permissions.elementAt(i);

        var invitedMember = FamilyMember(
          familyMemberId: -1,
          familyMemberName: "",
          familyMemberSurname: "",
          familyMemberEmail: email.text,
          familyMemberPassword: "",
          familyMemberRole: permission == "Admin permision approved" ? 1 : 0,
          familyGroupId: groupId,
        );

        Uri uri = Uri.parse("$api/FamilyMembers/inviteMembers");
        http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: familyMemberToJson(invitedMember),
        );
      }

      complete = true;
    }

    return complete;
  }

  Future<bool> createWeeklyTasks(TasksForTheWeek tasksForTheWeek) async {
    var complete = false;
    Uri uri = Uri.parse("$api/Tasks/createWeeklyTasks");
    var data = TasksForTheWeek.toJson(tasksForTheWeek);
    print(data);
    print(jsonEncode(TasksForTheWeek.toJson(tasksForTheWeek)));

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body:  jsonEncode(TasksForTheWeek.toJson(tasksForTheWeek))
    );

    if (response.statusCode == 200) {
      complete = true;
    }

    return complete;
  }

  Future<TasksForTheWeek> getWeeklyTasks() async {
    Uri uri = Uri.parse("$api/Tasks/getWeeklyTasks");
    var response = await http.get(uri);

    late TasksForTheWeek weeklyTasks;
    if (response.statusCode == 200) {
      weeklyTasks = jsonDecode(response.body);
    }

    return weeklyTasks;
  }
}
