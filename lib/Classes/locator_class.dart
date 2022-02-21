// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

class Locator {
  Future<Position?> getCurrentPosition() async {
    // bool serviceEnabled;
    // LocationPermission permission;

    // // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    print("Service enabled: $serviceEnabled");
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.deniedForever) {
    //     // Permissions are denied forever, handle appropriately.
    //     return Future.error(
    //         'Location permissions are permanently denied, we cannot request permissions.');
    //   }

    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }
    Position? currentPosition = await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.best,
        // forceAndroidLocationManager: true,
        );
    // .then((Position position) {
    //   // print(position);
    //   currentPosition = position;
    // }).catchError((err) {
    //   print('An error occured while getting current location : $err');
    // });
    print('This is the current location : $currentPosition');
    return currentPosition;
  }
}
