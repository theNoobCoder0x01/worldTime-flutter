import 'package:http/http.dart';
import 'dart:convert';
import 'package:worldtime/services/world_time.dart';

class Locations {

  static List<WorldTime> locations;

  static Future<void> getData() async {
    print("In file lib/services/locations.dart\n" +
        "class: Locations\n" +
        "method: getData()");
    try {
      const String api_url = 'http://api.timezonedb.com/v2.1/list-time-zone?key=V9BZU01KHECS&format=json';
      // String api_url = 'http://worldtimeapi.org/api/timezone';
      String response = (await get(api_url)).body;
      //Creates a List of Strings with url of the locations
      dynamic timeZones = jsonDecode(response);

      locations = [];
      int index = 0;
      for(dynamic zone in timeZones['zones']) {
        if(zone != null) {
          String locate = "";
          List<String> loc = zone['zoneName'].split('/');
          for(String lo in loc.reversed) {
            locate += lo + ", ";
          }
          locate = locate.substring(0, locate.length - 2);
          locations.add(WorldTime(location: locate,
              url: "$api_url&zone=${zone['zoneName']}&fields=gmtOffset",
              countryName: "${zone['countryName']} (${zone['countryCode']})"));
        }
        locations[index].gmtOffset = zone["gmtOffset"];
        index++;
      }
    }
    catch(e) {
      print("Caught Exception : $e");
    }
  }

}