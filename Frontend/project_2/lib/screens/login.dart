import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    logUserIn() {
      if (email.text.isEmpty || password.text.isEmpty) {
        print("email or password are empty");
      } else {
        print("Email: ${email.text}");
        print("Password: ${password.text}");
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: Container(
        decoration: BoxDecoration(color: Colors.red),
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

                Text("Forgot password"),

                SizedBox(
                  width: MediaQuery.widthOf(context) * 0.8,
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: () => logUserIn(),
                    child: Text("Login"),
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
