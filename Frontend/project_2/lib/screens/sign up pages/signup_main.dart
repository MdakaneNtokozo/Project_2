import 'package:flutter/material.dart';

class SignupMain extends StatefulWidget {
  const SignupMain({super.key});

  @override
  State<SignupMain> createState() => _SignupMainState();
}

class _SignupMainState extends State<SignupMain> {
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final List<String> items = ["Join household group", "Admin of household"];
  String? selectedItem;

  signUpUser() {
    if (email.text.isNotEmpty ||
        password.text.isNotEmpty ||
        name.text.isNotEmpty ||
        surname.text.isNotEmpty ||
        selectedItem != null) {
      print("Name: ${name.text}"); 
      print("Surname: ${surname.text}");
      print("Email: ${email.text}");
      print("Password: ${password.text}");

      if(selectedItem == items[0]){
        Navigator.pushNamed(context, "/signupGroupId");
      }else if(selectedItem == items[1]){
        Navigator.pushNamed(context, "/signupInvite");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 57, 166, 255)),
        alignment: AlignmentDirectional.center,
        child: Container(
          width: MediaQuery.widthOf(context) * 0.85,
          height: MediaQuery.heightOf(context) * 0.55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name"),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Surname"),
                      TextField(
                        controller: surname,
                        decoration: InputDecoration(
                          hintText: "Enter your surname",
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password"),
                      TextField(
                        controller: password,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select an option below"),
              
                      DropdownButtonFormField<String>(
                        items: items.map((String item){
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(), 
                        onChanged: (String? newSelected){
                          selectedItem = newSelected;
                        },
                        validator: (value){
                          if(value == null){
                            return "Please select an option";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
              
                  SizedBox(
                    width: MediaQuery.widthOf(context) * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () => signUpUser(),
                      child: Text("Sign up"),
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
