import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Components/button.dart';
import '../Components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: Colors.black54,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Lets create an account",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obsecureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obsecureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  // confirm password textField
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obsecureText: true),
                  const SizedBox(
                    height: 15,
                  ),

                  MyButton(
                      onTap: signUp,
                      text: "Sign Up"),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Login Now",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage("Passwords don't match");
      return;
    }
    // create the user
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //after creating the user, create a new document in the cloud firestore, called Users
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email)
      .set({
        'username' : emailController.text.split('@')[0],
        'bio' : 'Empty bio..'
      });
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code); // Replace with your error handling logic
    }
  }


  void displayMessage(String message) {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(message),
            ));
  }
}
