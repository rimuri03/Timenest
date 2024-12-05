import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TimeNestApp());
}

class TimeNestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeNest',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
