import 'package:flutter/material.dart';
import 'package:flutter_isolate/pages/home_page.dart';

class IsolateApp extends StatelessWidget {
  const IsolateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
