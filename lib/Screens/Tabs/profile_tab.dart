// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferroadsio/Classes/colors_class.dart';
import 'package:saferroadsio/Database/db_manager.dart';
import '../../Auth/login_screen.dart';
import '../../Database/auth_manager.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int currentBalance = 0;
  String fullName = '';
  int approvedPosts = 0;
  int declinedPosts = 0;
  final picker = ImagePicker();

  String newUsername = '';

  @override
  void initState() {
    super.initState();
    setCurrentBalance();
    fullName = getDisplayName();
    Future.delayed(Duration.zero, () async {
      approvedPosts = await getApprovedPosts();
      declinedPosts = await getDeclinedPosts();
    });
  }

  Future changeUsername(String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseManager manager = DatabaseManager();
    await manager.changeUsername(auth.currentUser?.uid, name);
  }

  void editUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey.shade300,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          side: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: SizedBox(
          width: 100,
          height: 250,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Edit Username",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Karla-Medium',
                          fontWeight: FontWeight.w700)),
                ),
                SizedBox(
                  width: 250,
                  height: 42,
                  child: TextField(
                    onChanged: (newText) {
                      setState(() {
                        newUsername = newText;
                      });
                      print('Username is changed to => $newUsername');
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
                      hintText: 'New Username',
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
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  height: 42,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(secondaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (newUsername != '') {
                        changeUsername(newUsername);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> getDeclinedPosts() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;
    return await manager.getDeclinedPosts(auth.currentUser?.uid);
  }

  Future<int> getApprovedPosts() async {
    DatabaseManager manager = DatabaseManager();
    FirebaseAuth auth = FirebaseAuth.instance;
    return await manager.getApprovedPosts(auth.currentUser?.uid);
  }

  void setCurrentBalance() async {
    DatabaseManager manager = DatabaseManager();
    int updatedBalance = await manager.getUserBalance();
    setState(() {
      currentBalance = updatedBalance;
    });
  }

  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => EditProfile(
  //       fullName: fullName,
  //     ),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(0.0, 1.0);
  //       var end = Offset.zero;
  //       var curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  String getDisplayName() {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        dynamic data = documentSnapshot.data();
        print('Document data: $data');
        setState(() {
          fullName = data['FullName'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade800,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // Stack(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8),
                  //       child: Align(
                  //         alignment: Alignment.topRight,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             Navigator.of(context).push(_createRoute());
                  //           },
                  //           child: const Text(
                  //             'edit',
                  //             style: TextStyle(
                  //               color: Color(0xFF8be9fd),
                  //               fontSize: 21,
                  //               fontFamily: 'Karla-Medium',
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            fullName,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 23,
                              fontFamily: 'Karla-Medium',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            editUsernameDialog(context);
                          },
                          child: Icon(
                            Icons.edit,
                            color: secondaryColor,
                            size: 23,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Current Balance : $currentBalance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                border: Border.all(
                  color: const Color(0xFF282a36),
                ),
              ),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Approved posts: ',
                        style: TextStyle(
                          fontFamily: 'Karla-Medium',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$approvedPosts',
                        style: const TextStyle(
                          fontFamily: 'Karla-Medium',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  Row(
                    children: [
                      const Text(
                        'Declined posts: ',
                        style: TextStyle(
                          fontFamily: 'Karla-Medium',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$declinedPosts',
                        style: const TextStyle(
                          fontFamily: 'Karla-Medium',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 200,
                height: 42,
                child: ElevatedButton(
                  onPressed: () async {
                    AuthManager manager = AuthManager();
                    await manager.signOut().then(
                      (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.red.shade400),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
