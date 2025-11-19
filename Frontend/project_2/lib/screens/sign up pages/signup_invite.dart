import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/models/family_member.dart';

class SignupInvite extends StatefulWidget {
  const SignupInvite({super.key});

  @override
  State<SignupInvite> createState() => _SignupInviteState();
}

class _SignupInviteState extends State<SignupInvite> {
  List<Widget> emailWidgets = [];
  int count = 0;
  List<TextEditingController> emails = [];
  List<String?> permissions = [];
  List<String> permissionOptions = [
    "Admin permission approved",
    "Admin permission denied",
  ];

  void addEmailWidget() {
    setState(() {
      emails.add(TextEditingController());
      permissions.add("");

      emailWidgets.add(
        SizedBox(
          width: MediaQuery.widthOf(context) * 0.8,
          height: MediaQuery.heightOf(context) * 0.2,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email"),
                  TextField(
                    controller: emails[count],
                    decoration: InputDecoration(
                      hintText: "Enter the family member's email",
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Admin permission"),
                  DropdownButtonFormField<String>(
                    items: permissionOptions.map((String p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (String? newSelected) {
                      permissions[count - 1] = newSelected;
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select an option";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      count++;
    });
  }

  void sendInvites(FamilyMember admin) {
    var result1 = ApiCalls().signUpAsFamilyAdmin(admin);

    result1.then((groupId){
      if (emails.length == permissions.length && emails.length > 0) {
        var result2 = ApiCalls().inviteUsers(
          emails,
          permissions,
          groupId,
        );
        result2.then(
          (complete) => {
            if (complete == true) {Navigator.pushNamed(context, "/home")},
          },
        );
      }else{
        Navigator.pushNamed(context, "/home");
      }
      });

    
  }

  @override
  Widget build(BuildContext context) {
    final FamilyMember admin =
        ModalRoute.of(context)!.settings.arguments as FamilyMember;

    return Scaffold(
      appBar: AppBar(title: Text("Sign up"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 57, 166, 255),
        ),
        alignment: AlignmentDirectional.center,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.widthOf(context) * 0.85,
            // height: MediaQuery.heightOf(context) * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Invite family members"),

                  emailWidgets.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: emailWidgets.length,
                          itemBuilder: (context, idx) {
                            return emailWidgets[idx];
                          },
                        )
                      : Text("There are no email sections added"),

                  ElevatedButton(
                    onPressed: addEmailWidget,
                    child: Text("Add email section"),
                  ),

                  SizedBox(
                    width: MediaQuery.widthOf(context) * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () => sendInvites(admin),
                      child: Text("Send invites"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
