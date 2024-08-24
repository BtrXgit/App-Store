import 'package:flutter/material.dart';
import 'package:store/routes/homepage.dart';
import 'package:store/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: StoreHomePage(),
      home: LofiMusicPlayer(),
    );
  }
}
