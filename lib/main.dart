import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'LogInScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      //remove banner from app
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
    );
  }

}