import 'package:flutter/material.dart';
import 'package:project_2/api_calls.dart';
import 'package:project_2/models/family_member.dart';

class SignupGroupId extends StatefulWidget {
  const SignupGroupId({super.key});

  @override
  State<SignupGroupId> createState() => _SignupGroupIdState();
}

class _SignupGroupIdState extends State<SignupGroupId> {
  TextEditingController id = TextEditingController();
  TextEditingController tempPassword = TextEditingController();

  void signUpUser(FamilyMember member) {
    if (id.text.isNotEmpty || tempPassword.text.isNotEmpty) {
      var result = ApiCalls().signUpInFamilyGroup(member, id.text, tempPassword.text);
      result.then(
        (signUpSuccessful) => {
          if (signUpSuccessful == true) {Navigator.pushNamed(context, "/home")},
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final FamilyMember member =
        ModalRoute.of(context)!.settings.arguments as FamilyMember;

    return Scaffold(
      appBar: AppBar(title: Text("Sign up"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 57, 166, 255),
        ),
        alignment: AlignmentDirectional.center,
        child: Container(
          width: MediaQuery.widthOf(context) * 0.85,
          height: MediaQuery.heightOf(context) * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Enter household group id"),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Household id"),
                    TextField(
                      controller: id,
                      decoration: InputDecoration(
                        hintText: "Enter your household id",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Temp password"),
                    TextField(
                      controller: tempPassword,
                      decoration: InputDecoration(
                        hintText: "Enter your temporary password",
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  width: MediaQuery.widthOf(context) * 0.8,
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () => signUpUser(member),
                    child: Text("Sign up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
