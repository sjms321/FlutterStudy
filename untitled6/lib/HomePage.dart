import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   bool gps=true;

  var weatherData;
  String url = "http://api.openweathermap.org/data/2.5/weather?";
  String lat = "";
  String lon = "";
  String appid = "appid=e6cd2ed81cc007e3087a551394dfeee3&";
  String units = "units=metric";


  void permission() async {
    await Geolocator.requestPermission();
    var value = await Geolocator.checkPermission();
    setState(() {
      if (value == LocationPermission.always ||
          value == LocationPermission.whileInUse)
        gps = true;
      else
        gps = false;
    });
  }

  Future getData()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    lat = "lat="+position.latitude.toString()+'&';
    lon= "lon="+position.longitude.toString()+'&';

    http.Response response = await http.get(
      Uri.encodeFull(url + lat + lon + appid + units),
      headers: {"Accept":"application/json"},
    );
    print("Response body: ${response.body}");
    weatherData = jsonDecode(response.body);
    return weatherData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getData();
        },
      ),

    );
  }
  @override
  void initState() {
    super.initState();
    permission();
  }
}


