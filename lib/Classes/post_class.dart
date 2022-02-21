import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    required this.violation,
    required this.description,
    required this.status,
    required this.mediaUrls,
    required this.mediaDetails,
    required this.numberPlate,
    required this.latitude,
    required this.longitude,
    required this.uploadTime,
  });

  final String violation;
  final String description;
  final String status;
  final List mediaUrls;
  final List mediaDetails;
  final String numberPlate;
  final double latitude;
  final double longitude;
  final Timestamp uploadTime;
}
