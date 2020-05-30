import 'package:flutter/material.dart';
import 'package:parchment/screens/main_screen.dart';
import 'package:parchment/services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parchment',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}