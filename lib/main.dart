import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;
  LocationData? _location;
  double? latitude1;
  double? longitude2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0.0,
        title: const Text("Location app"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 130,
              width: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  16,
                ),
                color: Colors.teal,
              ),
              child: Center(
                child: SelectableText(
                  'your current position is : \n\n\n' +
                      latitude1.toString() +
                      "    " +
                      longitude2.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'how to use this numbers to get your',
                style: TextStyle(),
              ),
              MaterialButton(
                child: const Text(
                  'Location ?',
                  style: const TextStyle(color: Colors.lightBlue),
                ),
                onPressed: () {
                  var e = AlertDialog(
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    content: Container(
                      height: 110,
                      child: Column(
                        children: [
                          const Divider(color: Colors.grey),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                              color: Colors.orange,
                            ),
                            child: const ListTile(
                              title: Text(
                                'you can copy this to number and paste in search icon in google map to see you current postion',
                                style: TextStyle(),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                  showDialog(context: context, builder: (context) => e);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> checkLocation() async {
    Location location = new Location();
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled == true) {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        print('its granted first ');
        location.onLocationChanged.listen((LocationData currentlocation) {
          setState(() {
            latitude1 = currentlocation.latitude;
            longitude2 = currentlocation.longitude;
          });
        });
        _location = await location.getLocation();
        print(_location!.latitude.toString() +
         "   " +
        _location!.longitude.toString());
      } else {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.granted) {
          print('excellent your are allowed');
        } else {
          SystemNavigator.pop();
        }
      }
      print('its enabled ');
    } else {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled == true) {
        _permissionGranted = await location.hasPermission();

        if (_permissionGranted == PermissionStatus.granted) {
          print('its granted second first');
        } else {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted == PermissionStatus.granted) {
            print('excellent you are allowed 2');
          } else {
            SystemNavigator.pop();
          }
        }
        print('start_tracking 2');
      } else {
        SystemNavigator.pop();
      }
    }
  }
}
