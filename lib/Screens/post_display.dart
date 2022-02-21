import 'package:flutter/material.dart';
import 'package:saferroadsio/Classes/colors_class.dart';
import '../Classes/post_class.dart';
import '../Components/display_box.dart';
import 'dart:async';

class PostDisplay extends StatefulWidget {
  const PostDisplay({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  _PostDisplayState createState() => _PostDisplayState();
}

class _PostDisplayState extends State<PostDisplay> {
  List<Widget> mediaUrls = [];

  @override
  void initState() {
    super.initState();
    setMediaUrls();
  }

  Future setMediaUrls() async {
    int idx = 0;

    widget.post.mediaUrls.forEach((url) {
      if (url != null) {
        setState(() {
          mediaUrls.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: widget.post.mediaDetails[idx]['mediaType'] == 'image'
                  ? SizedBox(
                      width: 350,
                      child: Image.network(
                        url,
                        // loadingBuilder: (BuildContext context, Widget child,
                        //     ImageChunkEvent loadingProgress) {
                        //   // if (loadingProgress == null) return child;
                        //   return Center(
                        //     child: CircularProgressIndicator(
                        //       value: loadingProgress.expectedTotalBytes != null
                        //           ? loadingProgress.cumulativeBytesLoaded /
                        //               loadingProgress.expectedTotalBytes
                        //           : null,
                        //     ),
                        //   );
                        // },
                      ),
                    )
                  : const Text(''),
            ),
          );
          idx += 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Post'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Violation : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.violation,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: mediaUrls,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Description : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.description,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Number Plate : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                      text: widget.post.numberPlate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Location : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                        text:
                            '(${widget.post.latitude.toStringAsFixed(2)}), (${widget.post.longitude.toStringAsFixed(2)})'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Upload Time : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    DisplayBox(
                        text: widget.post.uploadTime.toDate().toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Status : ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: secondaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                widget.post.status,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                widget.post.status == 'Approved'
                                    ? Icons.check
                                    : Icons.error,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
