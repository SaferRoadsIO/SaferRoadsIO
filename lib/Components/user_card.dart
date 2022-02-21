import 'package:flutter/material.dart';
import 'package:saferroadsio/Classes/colors_class.dart';
import '../Classes/app_user.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${user.currentBalance}',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 17,
                    ),
                  ),
                  const Text(' | ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(
                    '${user.displayName} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Karla-Medium',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
