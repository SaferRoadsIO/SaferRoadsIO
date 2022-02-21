// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'db_manager.dart';

class AuthManager {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseManager manager = DatabaseManager();

  Future<String?> login(String email, String password) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    }
  }

  Future<String> register(String firstName, String lastName, String email,
      String phoneNumber, String password) async {
    if (email != '' && password != '') {
      print("Regisering user...");

      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((UserCredential cred) async {
        print("Successfully registered user");
        String fullName = firstName + " " + lastName;
        await manager.saveUserData(
            firstName, lastName, fullName, email, phoneNumber);
        print("Success!");
        return 'Success';
      }).catchError((err) {
        print("ERROR IS $err");
        return err;
      });
      return 'Error';
    } else {
      print('Email and password cannot be empty');
      return 'Error';
    }
  }

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future signOut() async {
    await auth.signOut();
  }
}
