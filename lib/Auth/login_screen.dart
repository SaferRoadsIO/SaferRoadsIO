// ignore_for_file: avoid_print

import 'package:saferroadsio/Auth/register_screen.dart';
import 'package:saferroadsio/Database/auth_manager.dart';

import '../Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Classes/colors_class.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController isPasswordController = TextEditingController();
  String email = '';
  String password = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String errorMessage = 'Unknown Error';
  bool errorVisible = false;

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Text(
                      'SaferRoadsIO',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Karla-Medium',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/app-icon-nobg.png',
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: SizedBox(
                      width: 325,
                      height: 40,
                      child: TextField(
                        onChanged: (newText) {
                          setState(() {
                            email = newText;
                            print('Email is changed to => $email');
                          });
                        },
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Karla-Medium',
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 10),
                          hintText: 'Email..',
                          hintStyle: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.grey.shade700,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: SizedBox(
                      width: 325,
                      height: 40,
                      child: TextField(
                        onChanged: (newText) {
                          setState(() {
                            password = newText;
                            print('Password is changed to => $password');
                          });
                        },
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Karla-Medium',
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(top: 10),
                          hintText: 'Password..',
                          hintStyle: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.grey.shade700,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          AuthManager manager = AuthManager();
                          print("Email is $email\nPassword is $password");
                          String? status = await manager.login(
                            email,
                            password,
                          );
                          if (status == 'Success') {
                            print("Success");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                    // showWelcomePopup: false,
                                    // tab: 0,
                                    ),
                              ),
                            );
                          } else {
                            print("Error is $status");
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.cyan.shade400),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Karla-Medium',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Register here!',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
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
