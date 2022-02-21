import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Classes/app_user.dart';
import '../Components/user_card.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Image.asset('assets/images/trophy.gif'),
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF312c42),
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF4b4266),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Image.asset(
                'assets/images/trophy.gif',
                height: 150,
              ),
            ),
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .orderBy('CurrentBalance', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    dynamic docs = snapshot.data?.docs;
                    return ListView(
                      children: docs.map<Widget>((
                        QueryDocumentSnapshot document,
                      ) {
                        dynamic data = document.data();
                        AppUser user = AppUser(
                          uid: document.id,
                          displayName: data?['FullName'],
                          currentBalance: data['CurrentBalance'],
                        );
                        return UserCard(
                          user: user,
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
    );
  }
}
