import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rail app',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
      ),
      darkTheme: ThemeData(primaryColor: Colors.blueGrey[900]),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
