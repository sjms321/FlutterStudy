import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home:ContainerWidet()
    );
  }
}
class number{
  int num=0;
  number(){}
  get getnum{
    return num;
  }
}
class ContainerWidet extends StatelessWidget {
  var num = new number();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter example'),
      ),
      body:Container(
       child: RaisedButton(

         child: Text('Button'),

         onPressed: () {
           num.num++;
           print(num.num);
         },
         color: Colors.green,
         onLongPress: (){
           num.num++;
           num.num++;
           num.num++;
           print(num.num);
         },
         //둥글게 만들어주기
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
         ),
       ),

      )
      
    );
  }
}


