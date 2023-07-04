import 'package:flutter/material.dart';
import 'package:worldtime/services/locations.dart';
import 'package:worldtime/services/world_time.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    //Get the data from the previous screen i.e. /home; List of all locations is passed
    // Map data = ModalRoute.of(context).settings.arguments;
    // Locations.getData();
    List<WorldTime>? locations = Locations.locations;
    //If there was some issue in fetching locations list from api then set it to some test data
    //Although this would only happen if the link text is changed
    if (locations == null) {
      locations = [
        WorldTime(location: "Kolkata, Asia",
                  url: "http://api.timezonedb.com/v2.1/list-time-zone?key=V9BZU01KHECS&format=json&zone=Asia/Kolkata&fields=gmtOffset",
                  countryName: "India (IN)")
      ];
    }
    locations.sort();
    return Scaffold(
      //Creates a list view from the locations List
      body: SafeArea(
          child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                //If a tile is tapped then fetch the time data of the corresponding location
                //Also pop the current choose_location from route
                onTap: () async {
                  WorldTime instance = locations![index];
                  //Network request for time data from api
                  if(instance.gmtOffset == null) await instance.getData();
                  //Pop and return the fetched time data
                  Navigator.pop(context, {
                    'location' : instance.location,
                    'countryName' : instance.countryName,
                    'gmtOffset' : instance.gmtOffset,
                    'list_of_all_locations' : locations,
                  });
                },
                title: Text(locations![index].location),
                subtitle: Text("GMT Offset :- ${locations[index].gmtOffset}"),
              ),
            );
          }
        ),
      ),
    );
  }
}