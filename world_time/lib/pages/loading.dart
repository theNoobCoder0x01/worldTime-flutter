import 'package:flutter/material.dart';
import 'package:worldtime/services/locations.dart';
import 'package:worldtime/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; //Spin kit api for the spinner

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  //This function sets up the time data of the default location and gets the list of all locations
  void setupWorldTime() async {
    //This is the default location
    WorldTime instance = WorldTime(location: "Kolkata, Asia",
        countryName: "India (IN)",
        url: "http://api.timezonedb.com/v2.1/list-time-zone?key=V9BZU01KHECS&format=json&zone=Asia/Kolkata");
    //Get time data for default location from api
    await instance.getData();
    if(instance.gmtOffset == null) {
      instance.gmtOffset = 0;
      instance.location = "UTC";
      instance.countryName = "Universal Coordinated Time";
    }
    //Get list of all locations from api
    await Locations.getData();

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location' : instance.location,
      'countryName' : instance.countryName,
      'gmtOffset' : instance.gmtOffset,
    });
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //This is Ring spinner for the loading screen
        child: SpinKitRing(
          color: Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}