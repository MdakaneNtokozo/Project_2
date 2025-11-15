import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_2/models/family_member.dart';

class ApiCalls {
  var api = "";

  Future<Object> login(String email, String password) async {
    Uri uri = Uri.parse("$api ");
    var response = await http.post(uri);
    var loginSuccessful = false;

    if (response.statusCode == 200) {
      loginSuccessful = true;
    }

    return loginSuccessful;
  }

  Future<void> inviteUsers(
    List<TextEditingController> emails,
    List<String?> permissions,
  ) async {
    if (emails.length == permissions.length) {
      for (int i = 0; i < emails.length; i++) {
        var email = emails.elementAt(i);
        var permission = permissions.elementAt(i);

        var invitedMember = FamilyMember(
          familyMemberId: -1,
          familyMemberName: "",
          familyMemberSurname: "",
          familyMemberEmail: email.text,
          familyMemberPassword: Random().toString(),
          familyMemberRole: permission == "Admin permision approved" ? 1 : 0,
          familyGroupId: "admin's group id",
        );

        Uri uri = Uri.parse("$api ");
        http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: familyMemberToJson(invitedMember)
        );
      }
    }
  }
}
