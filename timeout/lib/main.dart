import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StopWatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> labTimes = []; //랩타임 기록

  //flutter에 존재하는 변수로 변수에 시간데이터를 저장한다.
  Stopwatch watch = Stopwatch(); //지속적으로 시간이 지나가는 변수

  String elapsedTime = '00:00:00:0000'; //경과시간을 기록하는 변수


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StopWatch'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                '$elapsedTime',
                style: TextStyle(fontSize: 25),
              ),
              padding: EdgeInsets.all(20),
            ),
            Container(
              width: 100,
              height: 200,
              child: ListView(
                children: labTimes.map((time)=>Text(time)).toList(),
              ),
            ),
            Container(
              width: 200,
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    child: !watch.isRunning ? Icon(Icons.play_arrow) : Icon(
                        Icons.stop)
                    ,
                    onPressed: () {
                      if(!watch.isRunning){
                        startWatch();
                      }else{
                        stopWatch();
                      }
                    },
                  ),
                  FloatingActionButton(
                    child: !watch.isRunning ? Text('Reset') : Text('Lab'),
                    onPressed: () {
                      if(!watch.isRunning){
                        resetWatch();
                      }else{
                        recordLapTime(elapsedTime);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  transTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hour = (minutes / 60).truncate();

    //뒤에서부터 두자리만 반환하겠다 만약 반환데이터가 없거나 비어있으면 0으로 출력하겠다
    String secondStr = (seconds % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String hourStr = (hour % 24).toString().padLeft(2, '0');

    return "$hourStr:$minutesStr:$secondStr:$milliseconds";
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transTime(watch.elapsedMilliseconds);
      });
    }
  }

  startWatch(){
    watch.start();
    Timer.periodic(Duration(microseconds: 100), updateTime);//100밀리세컨드마다 업데이트 된다.
  }
  stopWatch(){
    setState(() {
      watch.stop();
    });
  }

  resetWatch(){
      watch.reset();
      setTime();
      labTimes.clear();
  }

  setTime(){
    var timeFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime=transTime(timeFar);
    });
  }
  recordLapTime(String time){
    labTimes.insert(0, 'Lab ${labTimes.length+1} $time');
  }
}

