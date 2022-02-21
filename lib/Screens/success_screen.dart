import 'package:flutter/material.dart';
import 'package:saferroadsio/Screens/home_screen.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            tab: 1,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4b4266),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Success!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontFamily: 'Karla-Medium',
              ),
            ),
            const Center(
              child: Text(
                "Submitted to Police for approval!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Karla-Medium',
                ),
              ),
            ),
            Image.asset(
              "assets/images/success.gif",
              height: 125.0,
              width: 125.0,
            )
          ],
        ),
      ),
    );
  }
}
