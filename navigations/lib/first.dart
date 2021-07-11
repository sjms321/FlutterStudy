import 'package:flutter/material.dart';//


class FirstPage extends StatelessWidget {
  final String name;
  FirstPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
            child: Text('BACK'),
                onPressed: (){
                  Navigator.pop(context);
                }
                ),
            Text(name)

          ],
        ),
      ),
    );
  }
}
