// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:saferroadsio/Classes/colors_class.dart';
import 'package:saferroadsio/Database/auth_manager.dart';

import '../Screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final picker = ImagePicker();
  // File _profilePic = File('assets/images/app-icon-nobg.png');
  // Widget image = const CircleAvatar(
  //   backgroundImage: AssetImage('assets/images/avatar.png'),
  //   radius: 80,
  //   backgroundColor: Color(0xFF6272a4),
  // );
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';

  // Future<File> getProfilePic() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     // setState(() {
  //     _profilePic = File(pickedFile.path);
  //     // });
  //     if (_profilePic != null) {
  //       print("ProfilePic => $_profilePic");
  //       return _profilePic;
  //     }
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    // TextEditingController firstNameController = TextEditingController();
    // TextEditingController lastNameController = TextEditingController();
    // TextEditingController emailController = TextEditingController();
    // TextEditingController phoneNumberController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Karla-Medium',
                    fontSize: 30,
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
                        firstName = newText;
                        print('First name is changed to => $firstName');
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
                      hintText: 'First name..',
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
                        lastName = newText;
                        print('Last name is changed to => $lastName');
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
                      hintText: 'Last name..',
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
                        email = newText;
                      });
                      print('Email is changed to => $email');
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
                      print('Phone number is changed to => $newText');
                      setState(() {
                        phoneNumber = newText;
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
                      hintText: 'Phone number..',
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
                      print('Password is changed to => $newText');
                      setState(() {
                        password = newText;
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(
                          "First name is $firstName\n last name is $lastName\n Email is $email\n Phone number is $phoneNumber\n Password is $password");
                      AuthManager manager = AuthManager();
                      String status = await manager.register(
                        firstName,
                        lastName,
                        email,
                        phoneNumber,
                        password,
                      );

                      print('Status: $status');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            showWelcomePopup: true,
                            tab: 0,
                          ),
                        ),
                      );
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
                      'Register',
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
                'Already have an account?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Login here!',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
