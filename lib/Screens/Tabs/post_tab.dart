// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferroadsio/Classes/post_class.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Classes/colors_class.dart';
import '../../Classes/locator_class.dart';
import '../../Database/db_manager.dart';
import '../media_player.dart';
import 'dart:io';

import '../success_screen.dart';

class PostTab extends StatefulWidget {
  const PostTab({Key? key}) : super(key: key);

  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  String violation = 'Traffic Signal Violation';
  List<String> violations = [
    'Traffic Signal Violation',
    'Parking At No Parking Zone',
    'Bike Driving Without Helmet',
    'Speed Limit Violation',
    'Driving At Wrong Side Of Road',
    'Rash Driving',
    'Accidents',
    'Driving Vehicle Without License Plate',
  ];
  List<String> violationsRequiringVideos = [
    'Speed Limit Violation',
    'Rash Driving',
    'Accidents',
  ];
  List<Widget> mediaFiles = [];
  String numberPlate = 'Scanning number plates..';
  String description = '';
  String errorMessage = '';
  bool errorVisible = false;
  bool numberPlateVisible = false;
  final picker = ImagePicker();
  File? image;
  File? video;
  int images = 0;
  int videos = 0;
  List<File> files = [];
  List<Map> mediaDetails = [];
  Map mediaTypes = {};
  VideoPlayerController controller =
      VideoPlayerController.file(File('assets/images/trophy.gif'));
  double chanceOfApproval = 0;
  double evidenceQuantity = 0;
  double numberPlatePresent = 0;
  double descriptionPresent = 0;
  bool loadingBarVisible = false;
  bool loadingButtonVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      promptInput(context);
    });
  }

  void promptInput(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 125,
                width: 300,
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.black),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File image = await addImage();
                    setState(() {
                      mediaFiles.add(
                        MediaPlayer(
                          controller: null,
                          video: null,
                          image: image,
                          mediaType: 'image',
                          playButtonVisible: false,
                        ),
                      );
                      loadingBarVisible = false;
                    });
                  },
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 125,
                width: 300,
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color?>(Colors.green),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File video = await addVideo();
                    controller = VideoPlayerController.file(video)
                      ..initialize().then((_) {
                        setState(() {
                          mediaFiles.add(MediaPlayer(
                            image: null,
                            video: video,
                            controller: controller,
                            mediaType: 'video',
                            playButtonVisible: true,
                          ));
                          loadingBarVisible = false;
                        });
                      });
                  },
                  icon: const Icon(
                    Icons.video_call_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Video',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> addImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    DatabaseManager manager = DatabaseManager();
    Timestamp now = Timestamp.now();

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        numberPlateVisible = true;
        loadingBarVisible = true;
      });
      if (image != null) {
        print("Image successfully picked => $image");
        Locator locator = Locator();
        print("Getting location");
        Position? currentPos = await locator.getCurrentPosition();
        print("Location obtained $currentPos");
        setState(() {
          files.add(image!);
          images = images + 1;
          mediaTypes.addAll({'images': images});
          mediaDetails.add({
            'Latitude': currentPos?.latitude,
            'Longitude': currentPos?.longitude,
            'MediaUploadTime': now,
            'mediaType': 'image',
          });
        });
        print('images: $images\nvideos: $videos\nmediaTypes: $mediaTypes');
        if (images == 1 && videos == 0) {
          manager.createMediaDetails(mediaDetails, now);
        } else {
          manager.updateMediaDetails(mediaDetails, now);
        }

        print('Getting number plate');
        String numberPlateRef =
            await manager.getNumberPlate(image!, Timestamp.now());

        print('Number plate obtained: $numberPlateRef');

        setState(() {
          numberPlate = numberPlateRef;
          if (numberPlate == null || numberPlate == 'No Number Plate Found.') {
            numberPlatePresent = 0;
            chanceOfApproval = (evidenceQuantity * 0.35) +
                (numberPlatePresent * 0.35) +
                (descriptionPresent * 0.1);
          } else {
            numberPlatePresent = 100;
            chanceOfApproval = (evidenceQuantity * 0.35) +
                (numberPlatePresent * 0.35) +
                (descriptionPresent * 0.1);
          }
        });

        print("IMAGES + VIDEOS IS ${images + videos}");

        switch (images + videos) {
          case 0:
            setState(() {
              evidenceQuantity = 0;
              chanceOfApproval = (evidenceQuantity * 0.35) +
                  (numberPlatePresent * 0.35) +
                  (descriptionPresent * 0.1);
              print("CHANCE OF APPROVAL IS $chanceOfApproval");
            });
            break;
          case 1:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 20;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else {
              setState(() {
                evidenceQuantity = 30;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            }
            break;
          case 2:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 50;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else if (images == 2) {
              setState(() {
                evidenceQuantity = 40;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else if (images == 0) {
              setState(() {
                evidenceQuantity = 60;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            }
            break;
          case 3:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 80;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else if (images == 2) {
              setState(() {
                evidenceQuantity = 70;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else if (images == 3) {
              setState(() {
                evidenceQuantity = 60;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            } else {
              setState(() {
                evidenceQuantity = 90;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
                print("CHANCE OF APPROVAL IS $chanceOfApproval");
              });
            }
            break;
          default:
            setState(() {
              evidenceQuantity = 100;
              chanceOfApproval = (evidenceQuantity * 0.35) +
                  (numberPlatePresent * 0.35) +
                  (descriptionPresent * 0.1);
              print("CHANCE OF APPROVAL IS $chanceOfApproval");
            });
        }
      }
    } else {
      print('No image selected.');
    }
    return image!;
  }

  Future<File> addVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    DatabaseManager manager = DatabaseManager();
    Timestamp now = Timestamp.now();

    if (pickedFile != null) {
      setState(() {
        video = File(pickedFile.path);
        loadingBarVisible = true;
      });
      if (video != null) {
        print("Video successfully picked => $video");
        Locator locator = Locator();
        Position? currentPos = await locator.getCurrentPosition();
        setState(() {
          files.add(video!);
          videos = videos + 1;
          mediaTypes.addAll({'videos': images});
          mediaDetails.add({
            'Latitude': currentPos?.latitude,
            'Longitude': currentPos?.longitude,
            'MediaUploadTime': now,
            'mediaType': 'video',
          });
        });
        if (images == 0 && videos == 1) {
          manager.createMediaDetails(mediaDetails, now);
        } else {
          manager.updateMediaDetails(mediaDetails, now);
        }

        if (numberPlate == 'Scanning number plates..') {
          setState(() {
            numberPlate = 'No Number Plate Found.';
          });
        }
        print("IMAGES + VIDEOS IS ${images + videos}");
        switch (images + videos) {
          case 0:
            setState(() {
              evidenceQuantity = 0;
              chanceOfApproval = (evidenceQuantity * 0.35) +
                  (numberPlatePresent * 0.35) +
                  (descriptionPresent * 0.1);
            });
            break;
          case 1:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 20;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else {
              setState(() {
                evidenceQuantity = 30;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            }
            break;
          case 2:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 50;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else if (images == 2) {
              setState(() {
                evidenceQuantity = 40;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else if (images == 0) {
              setState(() {
                evidenceQuantity = 60;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            }
            break;
          case 3:
            if (images == 1) {
              setState(() {
                evidenceQuantity = 80;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else if (images == 2) {
              setState(() {
                evidenceQuantity = 70;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else if (images == 3) {
              setState(() {
                evidenceQuantity = 60;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            } else {
              setState(() {
                evidenceQuantity = 90;
                chanceOfApproval = (evidenceQuantity * 0.35) +
                    (numberPlatePresent * 0.35) +
                    (descriptionPresent * 0.1);
              });
            }
            break;
          default:
            setState(() {
              evidenceQuantity = 100;
              chanceOfApproval = (evidenceQuantity * 0.35) +
                  (numberPlatePresent * 0.35) +
                  (descriptionPresent * 0.1);
            });
        }
      }
    } else {
      print('No image selected.');
    }
    return video!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () {
          promptInput(context);
        },
        child: const Icon(
          Icons.camera_alt,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: backgroundColor,
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  const Text('Report A Crime',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Karla-Medium',
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 20),
                    child: DropdownButton<String>(
                      value: violation,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      items: violations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          violation = newValue!;
                          if (videos == 0) {
                            if (violationsRequiringVideos.contains(newValue)) {
                              errorMessage =
                                  'Please Provide Additional Evidence For Given Category';
                              errorVisible = true;
                            } else {
                              errorVisible = false;
                            }
                          }
                        });
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 15),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       promptInput(context);
                  //     },
                  //     style: ButtonStyle(
                  //       backgroundColor:
                  //           MaterialStateProperty.all<Color?>(secondaryColor),
                  //       shape: MaterialStateProperty.all(
                  //         RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //       ),
                  //     ),
                  //     child: const Text('Add Image/Video'),
                  //   ),
                  // ),
                  Visibility(
                    visible: loadingBarVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                          width: 50,
                          child: Image.asset('assets/images/loading.gif')),
                    ),
                  ),
                  Column(
                    children: mediaFiles,
                  ),
                  Visibility(
                    visible: numberPlateVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Number Plate: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Karla-Medium',
                              fontSize: 17,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: secondaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                              child: Text(
                                numberPlate,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Karla-Medium',
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: 260,
                      height: 42,
                      child: TextField(
                        // maxLines: null,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Karla-Medium',
                        ),
                        onChanged: (String text) {
                          print("Description is $text");
                          description = text;
                          if (text == '') {
                            setState(() {
                              descriptionPresent = 0;
                              chanceOfApproval = (evidenceQuantity * 0.35) +
                                  (numberPlatePresent * 0.35) +
                                  (descriptionPresent * 0.1);
                              errorMessage = 'Please Provide a description';
                              errorVisible = true;
                            });
                          } else {
                            setState(() {
                              descriptionPresent = 100;
                              chanceOfApproval = (evidenceQuantity * 0.35) +
                                  (numberPlatePresent * 0.35) +
                                  (descriptionPresent * 0.1);
                              errorVisible = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          hintText: 'Description..',
                          hintStyle: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.grey.shade700,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: errorVisible,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Color(0xFFff5555),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Chance of Approval: ${chanceOfApproval.round()}%",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Karla-Medium',
                      ),
                    ),
                  ),
                  Visibility(
                    visible: loadingButtonVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                          width: 50,
                          child: Image.asset('assets/images/loading.gif')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 50),
                    child: SizedBox(
                      width: 260,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loadingButtonVisible = true;
                          });
                          DatabaseManager manager = DatabaseManager();
                          Locator locator = Locator();
                          Position? currentPos =
                              await locator.getCurrentPosition();
                          Timestamp now = Timestamp.now();
                          Post post = Post(
                            violation: violation,
                            description: description,
                            status: 'Unknown',
                            mediaUrls: [],
                            mediaDetails: mediaDetails,
                            numberPlate: numberPlate,
                            latitude: (currentPos?.latitude)!,
                            longitude: (currentPos?.longitude)!,
                            uploadTime: now,
                          );
                          print("Submit to police");
                          await manager.uploadPost(post);
                          await manager.uploadFiles(files, now);
                          await manager.uploadNumberPlate(numberPlate);
                          await manager.uploadPostToPolice(post, now);
                          setState(() {
                            loadingButtonVisible = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Success()));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(secondaryColor),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Submit to Police',
                          style: TextStyle(
                            fontFamily: 'Karla-Medium',
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
