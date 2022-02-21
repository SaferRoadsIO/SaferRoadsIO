import '../Classes/post_class.dart';
import 'package:flutter/material.dart';
import '../Screens/post_display.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  String getTime(String str) {
    if (str != '' && str.length >= 7) {
      str = str.substring(0, str.length - 7);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    Color statusRoom = Colors.grey.shade600;
    if (post.status == 'Approved') {
      statusRoom = const Color(0xFF50fa7b);
    } else if (post.status == 'Declined') {
      statusRoom = const Color(0xFFff5555);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDisplay(
              post: post,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(
              color: Colors.black,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Violation: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flexible(
                      child: Text(
                        post.violation,
                        style: TextStyle(
                          color: Colors.cyan.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Description: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    Flexible(
                      child: Text(
                        post.description,
                        style: TextStyle(
                          color: Colors.cyan.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Location: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      '(${post.latitude}), (${post.longitude})',
                      style: TextStyle(
                        color: Colors.cyan.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Upload Time: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      getTime(post.uploadTime.toDate().toString()),
                      style: TextStyle(
                        color: Colors.cyan.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Number Plate: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      post.numberPlate,
                      style: TextStyle(
                        color: Colors.cyan.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      post.status,
                      style: TextStyle(
                        color: statusRoom,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
