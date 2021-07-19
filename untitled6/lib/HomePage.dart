import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  DateFormat formatter = DateFormat('H시 m분 s초');
  var textground =  Color(0xFFB1D1CF);
  String image = "";
  DateFormat sun = DateFormat('H시 m분');

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
      image = "images/cold_mountain.png";
      textground = Color(0xFF9DBBB9);
      print('cold');
    }else{
      background = Color(0xFFF5CE8B);
      image = "images/hot_mountain.png";
      textground = Color(0xFFE5AB48);
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
                  Text('Weather Apps',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: background),),
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
                       ),
                       
                       //step4
                       Image.network('http://openweathermap.org/img/wn/'+weatherData['weather'][0]['icon']+'@2x.png'),
                       //이미지 위치와 화면의 너비만큼 이미지구성
                      Image.asset(image,width: MediaQuery.of(context).size.width),

                       //step5
                       Container(
                         padding:  EdgeInsets.only(right: 10,top: 10),
                         alignment: Alignment.centerRight,
                         child: Text('Last Update: ${formatter.format(DateTime.now())}'),
                       ),
                       Container(
                         width: MediaQuery.of(context).size.width,
                         child: Card(
                           color: textground,
                           child: Container(
                             padding: EdgeInsets.all(10),
                             margin: EdgeInsets.all(10),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('More Information',
                                 style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                 SizedBox(height: 10,),
                                 IntrinsicHeight(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [ 
                                       Icon(Icons.water_damage,color: Colors.white,),
                                       Column(
                                         children: [
                                           Text('Humidity'),
                                           Text('${snapshot.data['main']['humidity']}%'),
                                         ],
                                       ),

                                       VerticalDivider(color: Colors.white,),

                                       Icon(Icons.remove_red_eye,color: Colors.white,),
                                       Column(
                                         children: [
                                           Text('Visibility'),
                                           Text('${snapshot.data['visibility']}'),
                                         ],
                                       ),

                                       VerticalDivider(color: Colors.white,),

                                       Icon(Icons.water_damage,color: Colors.white,),
                                       Column(
                                         children: [
                                           Text('Country'),
                                           Text('${snapshot.data['sys']['country']}'),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                                SizedBox(height: 20,),
                                 IntrinsicHeight(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       infoSpace(Icons.speed,'Wind Speed' , '${snapshot.data['wind']['speed']}'),
                                       VerticalDivider(color: Colors.white,),
                                       infoSpace(Icons.rotate_90_degrees_ccw,'Wind Deg' , '${snapshot.data['wind']['deg']}'),
                                     ],
                                   ),
                                 ),

                                 SizedBox(height: 20,),

                                 IntrinsicHeight(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       infoSpace(Icons.wb_sunny,'Sunset' , sun.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data['sys']['sunset']*1000))),
                                       VerticalDivider(color: Colors.white,),
                                       infoSpace(Icons.nights_stay,'Sunrise' , sun.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data['sys']['sunrise']*1000))),
                                     ],
                                   ),
                                 ),

                               ],

                             ),

                           ),


                         ),
                       ),
                       SizedBox(height: 20,),

                     ],
                   ),
                 );
               })
            ]),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('http://openweathermap.org/img/wn/'+weatherData['weather'][0]['icon']+'@2x.png');
      //   },
      // ),
    );
  }
  Widget infoSpace(IconData icons,String topText,String bottomText){
    return Container(
      width: MediaQuery.of(context).size.width/2-50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icons,color: Colors.white,),
          Container(
            width: MediaQuery.of(context).size.width/5,
            child: Column(
              children: [
                Text(topText),
                Text(bottomText)
              ],
            ),
          )
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    permission();
  }

}

