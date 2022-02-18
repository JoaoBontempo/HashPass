import 'package:flutter/material.dart';
import 'package:hashpass/Themes/colors.dart';
import 'package:hashpass/Themes/light.dart';
import 'package:hashpass/View/index.dart';
import 'package:hashpass/View/splashpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Pass',
      theme: LightAppTheme(context).defaultTheme,
      home: HashPasshSplashPage(),
    );
  }
}
