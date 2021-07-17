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
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  bool gps = true;

  var weatherData;
  String url = "http://api.openweathermap.org/data/2.5/weather?";
  String lat = "";
  String lon = "";
  String appid = "appid=e6cd2ed81cc007e3087a551394dfeee3&";
  String units = "units=metric";
  var background = Color(0xFFB1D1CF);


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

  Future getData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    lat = "lat=" + position.latitude.toString() + '&';
    lon = "lon=" + position.longitude.toString() + '&';

    http.Response response = await http.get(
      Uri.encodeFull(url + lat + lon + appid + units),
      headers: {"Accept": "application/json"},
    );
    print("Response body: ${response.body}");
    weatherData = jsonDecode(response.body);

    if(weatherData['main']['temp']<22){
      background =Color(0xFFB1D1CF);
      print('cold');
    }else{
      background = Color(0xFFF5CE8B);
      print('hot');
    }
    return weatherData;
  }

  Future<Null> _onReFresh() async {
    setState(() {});
    print('d');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top), //상태창아래로
              child: Row(
                children: [
                  Text(
                    'weather Apps',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(), //화면 우측에 아이콘 위치시킴
                  IconButton(
                      onPressed: () {
                        print('a');
                      },
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                'https://cdn.gukjenews.com/news/photo/202102/2154608_2147950_457.jpg'))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'reasley',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'sjms321@naver.com',
                    style: TextStyle(color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onReFresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
                children: [
              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      _scaffoldkey.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu),
                  ),
                  Spacer(),
                  Text('Weatjer Apps'),
                  Spacer(),
                  gps == true
                      ? IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: () {
                      _scaffoldkey.currentState!
                          .showSnackBar(SnackBar(content: Text('위치정보정상')));
                      getData();
                    },
                  )
                      : IconButton(
                    icon: Icon(Icons.gps_not_fixed),
                    onPressed: () {
                      _scaffoldkey.currentState!
                          .showSnackBar(SnackBar(content: Text('위치정보비정상')));
                    },
                  )
                ],
              ),

             FutureBuilder(
               future: getData(),
               builder: (BuildContext context, AsyncSnapshot snapshot){
                 if(!snapshot.hasData)return CircularProgressIndicator();
                 return Container(
                   color: background,
                   child: Column(

                     children: [

                       SizedBox(

                         height: 40,
                       ),
                       Text("${snapshot.data['weather'][0]['main']}",
                       style: TextStyle(
                         fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold
                       ),),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,

                         children: [
                           Icon(Icons.location_on, color: Colors.white,size: 18,),
                           Text("${snapshot.data['name']}",
                           style: TextStyle(
                             fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold
                           ),)
                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text("${snapshot.data['main']['temp'].toStringAsFixed(0)}",
                           style: TextStyle(
                             fontSize: 65,color: Colors.white,fontWeight: FontWeight.bold
                             //소수점없이 표시
                           ),),
                           Column(
                             children: [
                               Text('ºC',
                               style: TextStyle(
                                 fontSize: 28,color:Colors.white,fontWeight: FontWeight.bold
                               ),),
                               Row(
                                 children: [
                                   Icon(Icons.keyboard_arrow_up,color: Colors.white,size: 15,),
                                   Text("${snapshot.data['main']['temp_max'].toStringAsFixed(0)}ºC"
                                   ,style: TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold),),

                                 ],
                               ),
                               Row(
                                 children: [
                                   Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 15,),
                                   Text("${snapshot.data['main']['temp_min'].toStringAsFixed(0)}ºC"
                                     ,style: TextStyle(fontSize: 15,color:Colors.white,fontWeight: FontWeight.bold),)
                                 ],
                               )
                             ],
                           )
                         ],
                       )
                     ],
                   ),
                 );
               })
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    permission();
  }
}
