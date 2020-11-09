import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Map data = {};

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    //Declarations of required variables
    String location;
    String countryName;
    Duration gmtOffset;
    // String bgImage;
    Color bgColor;
    bool isDayTime;
    AssetImage theme;

    DateTime getTime() => (DateTime.now().toUtc().add(gmtOffset));

    try {
      //If data received from the previous path is empty try using the data from loading screen
      data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
      location = data['location'];
      countryName = data['countryName'];
      gmtOffset = Duration(seconds: data['gmtOffset']);
      isDayTime = getTime().hour > 6 && getTime().hour < 18;
      theme = AssetImage('assets/${isDayTime ? 'day.png' : 'night.png'}');
      bgColor = isDayTime ? Colors.blue : Colors.indigo[700];
    }
    catch(e) {
      print("Caught exception in getting data...\nException : $e");
      //These code will only run if there is an error in fetching data from world time api
      // bgImage = "black.png";
      theme = AssetImage('assets/black.png');
      bgColor = Colors.black;
      gmtOffset = Duration(seconds: 0);
      location = "UTC";
      countryName = "Universal Coordinated Time";
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
            DateTime time = getTime();
            isDayTime = time.hour > 6 && time.hour < 18;
            theme = AssetImage('assets/${isDayTime ? 'day.png' : 'night.png'}');
            bgColor = isDayTime ? Colors.blue : Colors.indigo[700];
            dynamic n = DateFormat.jms().format(time).split(":");
            String hour = n[0];
            String minute = n[1];
            int second = int.parse(n[2].substring(0, 2));
            String period = n[2].toString().substring(n[2].length - 2);
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${isDayTime ? 'day.png' : 'night.png'}'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 160.0, 0, 0),
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        //Received the data returned from the choose_location screen in result variable
                        //Also passed in the list of all locations that was fetched in from loading screen
                        dynamic result = await Navigator.pushNamed(context, "/choose_location");
                        //Updating the data map received from previous screen
                        setState(() {
                          data = result;
                        });
                      },
                      icon: Icon(
                        Icons.edit_location,
                        color: Colors.grey[200],
                      ),
                      label: Text(
                        "Edit Location",
                        style: TextStyle(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          location + "\n$countryName",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "$hour",
                              style: TextStyle(
                                fontSize: 66.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              child: Text(
                                ":",
                                style: TextStyle(
                                  fontSize: 60.0,
                                  color: second % 2 == 0 ? Colors.white : Colors.grey[600],
                                ),
                              ),
                              width: 20.0,
                            ),
                            Text(
                              "$minute",// $period",
                              style: TextStyle(
                                fontSize: 66.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              child: Text(
                                ":",
                                style: TextStyle(
                                  fontSize: 60.0,
                                  color: second % 2 == 0 ? Colors.white : Colors.grey[600],
                                ),
                              ),
                              width: 20.0,
                            ),
                            Text(
                              "$second $period",
                              style: TextStyle(
                                fontSize: 66.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0,),
                        Text(
                          "${DateFormat.EEEE().format(time)}, ${DateFormat.d().format(time)} ${DateFormat.MMMM().format(time)}",
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}