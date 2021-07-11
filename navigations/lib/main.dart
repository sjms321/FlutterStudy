import 'package:flutter/material.dart';

import 'first.dart';
import 'second.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
                child: Text('FirstPage'),
                onPressed: () async {
                  final name = 'flutter';
                  final res = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FirstPage(name: 'flutter',)));

                }),
            RaisedButton(
                child: Text('SecondPage'),
                onPressed: () async {
                  final res = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                  print(res);
                })
          ],
        ),
      ),
    );
  }
}
