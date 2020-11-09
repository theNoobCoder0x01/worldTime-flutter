import 'package:http/http.dart'; //Library for performing network requests
import 'dart:convert'; //Library for converting json (String) data to Flutter objects

class WorldTime implements Comparable<WorldTime> {

  String location; //Location name for the UI
  String countryName;
  int gmtOffset;
  String url; //Location url for api endpoint

  WorldTime({ this.location, this.url, this.countryName });

  Future<void> getData() async {
    print("In file lib/services/world_time.dart\n" +
        "class: WorldTime\n" +
        "method: getData()");
    try {
      //Make the network request and convert the data to a map
      // Map data = jsonDecode((await get('http://worldtimeapi.org/api/timezone/$url')).body);
      print(this.url);
      Map data = jsonDecode((await get(this.url)).body);
      this.gmtOffset = data['zones'][0]['gmtOffset'];
      print(this.gmtOffset);
    }
    catch(e) {
      print("Exception in file \"world_time.dart\"");
      print("Caught Exception : $e");
      this.gmtOffset = null;
    }
  }

  @override
  int compareTo(WorldTime other) {
    int b = this.location.compareTo(other.location);
    if(b == 0) {
      return this.countryName.compareTo(other.countryName);
    }
    return b;
  }
}