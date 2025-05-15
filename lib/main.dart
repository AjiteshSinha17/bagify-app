import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(BagifyApp());
}

class BagifyApp extends StatelessWidget {
  const BagifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAGIFY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}