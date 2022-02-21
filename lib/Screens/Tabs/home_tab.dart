import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saferroadsio/Classes/colors_class.dart';
import 'package:saferroadsio/Classes/post_class.dart';
import 'package:saferroadsio/Database/auth_manager.dart';
import '../../Components/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../leaderboard_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  User? currentUser;

  Future setCurrentUser() async {
    AuthManager manager = AuthManager();
    User? user = await manager.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await setCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Leaderboard(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      border: const Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Leaderboard",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 50,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Recent Uploads",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 750,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currentUser?.uid)
                        .collection('Posts')
                        .orderBy('UploadTime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData || currentUser == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        dynamic docs = snapshot.data?.docs;
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: docs.map<Widget>((
                            QueryDocumentSnapshot document,
                          ) {
                            dynamic data = document.data();
                            return PostCard(
                              post: Post(
                                violation: data['Violation'],
                                description: data['Description'],
                                status: data['Status'],
                                mediaUrls: data['Media-Urls'],
                                mediaDetails: data['Media-Details'],
                                numberPlate: data['NumberPlate'],
                                latitude: data['Latitude'],
                                longitude: data['Longitude'],
                                uploadTime: data['UploadTime'],
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
