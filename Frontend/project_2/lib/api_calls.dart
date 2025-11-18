import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_2/models/completed_tasks.dart';
import 'package:project_2/models/family_member.dart';
import 'package:project_2/models/week.dart';
import 'package:project_2/tasks_for_the_week.dart';

class ApiCalls {
  //var api = "http://localhost:5063/api";
  var api = "http://10.220.36.84:45455/api";

  Future<FamilyMember?> login(String email, String password) async {
    Uri uri = Uri.parse(
      "$api/FamilyMembers/login?email=$email&password=$password",
    );
    var response = await http.get(uri);
    FamilyMember? loggedInMember;

    if (response.statusCode == 200) {
      loggedInMember = familyMemberFromJson(response.body);
    }

    return loggedInMember;
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
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: tasksForTheWeekToJson(tasksForTheWeek),
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
      weeklyTasks = tasksForTheWeekFromJson(response.body);
    }

    return weeklyTasks;
  }

  Future<bool> updateWeeklyTasks(TasksForTheWeek weeklyTasks) async {
    Uri uri = Uri.parse("$api/Tasks/updateWeeklyTasks");
    var response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: tasksForTheWeekToJson(weeklyTasks),
    );
    bool updated = false;

    if (response.statusCode == 200) {
      updated = true;
    }

    return updated;
  }

  Future<bool> deleteWeeklyTasks(Week week) async {
    Uri uri = Uri.parse("$api/Tasks/deleteWeeklyTasks?weekId=${week.weekId}");
    var response = await http.delete(uri);
    bool deleted = false;

    if (response.statusCode == 200) {
      deleted = true;
    }

    return deleted;
  }

  Future<List<CompletedTask>> getCompletedTasks() async {
    Uri uri = Uri.parse("$api/Tasks/getCompletedTasks");
    var response = await http.get(uri);
    List<CompletedTask> completedTasks = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      for(int i = 0; i < data.length; i++){
        completedTasks.add(CompletedTask.fromJson(data[i]));
      }

    }

    return completedTasks;
  }

  Future<bool> addCompletedTask(int memberId, int taskId) async{
    var isAdded = false;

    var completedTask = CompletedTask(
      taskId: taskId, 
      familyMemberId: memberId, 
      timeCompleted: DateTime.now()
    );

   Uri uri = Uri.parse("$api/Tasks/addCompletedTask");
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: completedTaskToJson(completedTask),
    );

    if (response.statusCode == 200) {
      isAdded = true;
    }

    return isAdded;
  }

  Future<bool> deleteCompletedTask(int memberId, int taskId) async{
    var isDeleted = false;

    var completedTask = CompletedTask(
      taskId: taskId, 
      familyMemberId: memberId, 
      timeCompleted: DateTime.now()
    );

   Uri uri = Uri.parse("$api/Tasks/deleteCompletedTask");
    var response = await http.delete(
      uri,
      headers: {"Content-Type": "application/json"},
      body: completedTaskToJson(completedTask),
    );

    if (response.statusCode == 200) {
      isDeleted = true;
    }

    return isDeleted;
  }


}
