import 'package:credit_cards/3d/animation_controller.dart';
import 'package:credit_cards/3d/main_controller.dart';
import 'package:credit_cards/biometric/biometric.dart';
import 'package:credit_cards/card.dart';
import 'package:credit_cards/design_ideas/fab.dart';
import 'package:credit_cards/platform-channels/platform.dart';
import 'package:credit_cards/animation/app.dart';
import 'package:credit_cards/animation/credit_card_widget.dart';
import 'package:credit_cards/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xff333333),
        accentColor: Colors.green,
        lightSource: LightSource.topLeft,
        depth: 4,
        intensity: 0.3,
      ),
      theme: NeumorphicThemeData(
        baseColor: Color(0xffDDDDDD),
        accentColor: Colors.cyan,
        lightSource: LightSource.topLeft,
        depth: 6,
        intensity: 0.5,
      ),
      home: TextPage(),
    );
  }
}
