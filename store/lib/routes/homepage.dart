import 'package:flutter/material.dart';

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0e1c),
      body: Center(),
    );
  }
}

Widget _appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: Row(
      children: [
        Row(
          children: [],
        )
      ],
    ),
  );
}
