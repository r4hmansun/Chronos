import 'package:flutter/material.dart';

void main (){
    runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
    const MyWidget({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(appBar: AppBar(
                title: Text("Image"),
            ),
            body: ListView(
                scrollDirection: Axis.vertical,
                children: [
                    Container(
                        height: 300,
                        width: 300,
                        color: Colors.amber,
                        child: Image.asset("images/OIP.jpg"),
                    ),
                     Container(
                        height: 300,
                        width: 300,
                        color: Colors.purple,
                        
                    ),
                     Container(
                        height: 300,
                        width: 300,
                        color: Colors.blue,
                    ),
                     Container(
                        height: 300,
                        width: 300,
                        color: Colors.red,
                    )
                ],
            ),
   ),
  );
 }
}