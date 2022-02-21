// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'Tabs/home_tab.dart';
import 'Tabs/post_tab.dart';
import 'Tabs/profile_tab.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    this.showWelcomePopup = false,
    required this.tab,
  }) : super(key: key);

  bool showWelcomePopup = false;
  int tab;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.showWelcomePopup == true) {
        showWelcomePopup();
      } else {
        setState(() {
          switch (widget.tab) {
            case 0:
              tab = PostTab();
              break;
            case 1:
              tab = HomeTab();
              break;
            case 2:
              tab = ProfileTab();
              break;
            default:
          }
        });
      }
    });
  }

  void showWelcomePopup() {
    String text = '''
We're glad you're onboard with us! Here's how you can get started!

1) Add Your First Post
  -> Upon dismissing this popup, you'll be prompted to choose either video or image
  -> Select the type of media you want to choose
  -> Select the category of the violation using the dropdown
  -> Write a description of the violation
  -> Submit the violation to the traffic police by clicking the button!

Easy isn't it? You can view our top contributors through the leaderboard from Home tab.
View your recent posts from the home tab too!
    ''';

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        height: 470,
        decoration: BoxDecoration(
          color: const Color(0xFF4b4266),
          border: Border.all(
            color: const Color(0xFFff79c6),
            width: 3.0,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(
                'Welcome To RoadLance!',
                style: TextStyle(
                  color: Color(0xFF50fa7b),
                  fontFamily: 'Karla-Medium',
                  fontSize: 26,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Karla-Medium',
                    fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      print("Modal closed!");
      setState(() {
        tab = PostTab();
      });
    });
  }

  int _selectedIndex = 0;
  Widget tab = PostTab();

  void onItemTapped(int index) {
    print("New index is $index");
    setState(() {
      _selectedIndex = index;
    });
    setState(() {
      switch (_selectedIndex) {
        case 0:
          tab = PostTab();
          break;
        case 1:
          tab = HomeTab();
          break;
        case 2:
          tab = ProfileTab();
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab,
      backgroundColor: const Color(0xFF4b4266),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF282a36),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
