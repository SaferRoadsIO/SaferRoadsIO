// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferroadsio/Database/db_manager.dart';
import 'Tabs/profile_tab.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.fullName}) : super(key: key);

  final String fullName;
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = '';
  bool loadingButtonVisible = false;

  Future changeUsername() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DatabaseManager manager = DatabaseManager();
    await manager.changeUsername(auth.currentUser?.uid, name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4b4266),
      appBar: AppBar(
        backgroundColor: const Color(0xFF312c42),
        centerTitle: true,
        title: const Text('Edit Profile'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileTab(),
                ),
              );
            }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
              child: TextFormField(
                onChanged: (newText) {
                  setState(() {
                    name = newText;
                    print("Name is now $name");
                  });
                },
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      // color: Color(0xFF8be9fd),
                      color: Colors.white,
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
                initialValue: widget.fullName,
                style: const TextStyle(
                  color: Color(0xFF50fa7b),
                  fontFamily: 'Karla-Medium',
                  fontSize: 22,
                ),
              ),
            ),
            Visibility(
              visible: loadingButtonVisible,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: SizedBox(width: 50, child: Text('Loading')),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loadingButtonVisible = true;
                });
                print("Changing username");
                if (name != '') {
                  await changeUsername();
                }
                setState(() {
                  loadingButtonVisible = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileTab(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color?>(Colors.cyan.shade400),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Karla-Medium',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
