import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? latitude;
  String? longitude;
  bool? isMock;
  bool showText = false;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    final permission = await Permission.location.request();
    if (permission == PermissionStatus.granted) {
      TrustLocation.start(10);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitude = result.latitude;
          longitude = result.longitude;
          isMock = result.isMockLocation;
          showText = true;
        });
      });
      geoCode();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    TrustLocation.stop();
    super.dispose();
  }

  void geoCode() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(latitude!), double.parse(longitude!));
    print(placemarks[0].country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(showText
              ? "Lat: $longitude\n Mock Location: $isMock"
              : "Mock Location: $isMock")),
    );
  }
}
