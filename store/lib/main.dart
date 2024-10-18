import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store/firebase_options.dart';
import 'package:store/routes/homepage.dart';
import 'package:store/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      home: const StoreHomePage(),
    );
  }
}
