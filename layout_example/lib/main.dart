import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Layout extends StatefulWidget {

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  bool star = true;
  int count = 41;

  @override
  Widget build(BuildContext context) {
    Widget imageSection = Image.network(
      'https://mblogthumb-phinf.pstatic.net/MjAxODA5MjdfMjE0/MDAxNTM4MDU1OTM1NDc4.yKkwg8z2KNeN-bPn4tunmtYacBvWhbJAfNVnWogLTbYg.AvgRv37qxdhD7fT3w2cXxlPUy2QXQUYudGoA4WGSpGcg.JPEG.donation/batc5h_20180925_163533.jpg?type=w800',
      height: 240,
      width: 600,
      fit: BoxFit.cover,
    );

    Widget titleSection =  Container(
        padding: EdgeInsets.all(32),
        //컨테이너에 넣어 사이즈를 할당하여 사용한다.

        child: GestureDetector(
          onTap: () {
            print('click');
          },
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //글자를 왼쪽으로 밀착
                  children: [
                    //타이틀
                    Text(  '호수 캠핑장',style: TextStyle(fontWeight: FontWeight.bold),),
                    //서브
                    Text( '강화도',style: TextStyle(color: Colors.grey[500] //500-> 색상의 농도와 밝기를 지정할 수 있음.500이 기본값
                    ),
                    ),],),),
             IconButton(
                 icon:star
                 ? Icon(Icons.star)//참일경우
                 : Icon(Icons.star_border),//거짓일경우
                 color: Colors.red,onPressed: (){
               setState(() { //요걸 넣어야지만 변경된 상태를 ui적용할 수 있다.
                 if(star){
                   star = !star;
                   count--;

                 }else{
                   star = !star;
                   count++;
                 }
               });
             },),
              Text('$count'),
            ],),));

    Widget buttonSection = //ButtonSection
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, //동일하게 띄우기
      children: [
        Column(
          children: [
            IconButton(
              icon : Icon(Icons.call),
              color: Colors.blue,
              onPressed: (){

              },
            ),
            Text('CALL',style: TextStyle(color: Colors.blue),)
          ],
        ),
        Column(
          children: [
            Icon(Icons.near_me,color: Colors.blue,),
            Text('ROUTE',style: TextStyle(color: Colors.blue),)
          ],
        ),
        Column(
          children: [
            Icon(Icons.share,color: Colors.blue,),
            Text('SHARE',style: TextStyle(color: Colors.blue),)
          ],
        ),
      ],
    );

    Widget textSection =  Container(
      padding: EdgeInsets.all(32),
      child: Text(
        '최고의 캠핑장 강화 호수 캠핑장으로 오세요잇~!',
        style: TextStyle(color: Colors.grey[600],fontSize: 15),
      ),
    );

    return Scaffold(

      appBar: AppBar(
        title: Text('캠핑 고고!',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[900],
      ),

      body: ListView(
        children: [
          imageSection,
          titleSection,
          buttonSection,
          textSection
        ],
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Layout());
  }
}

