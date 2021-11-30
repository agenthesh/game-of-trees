import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/demoModel.dart';
import 'package:game_of_trees/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainGameScreen.dart';

late SharedPreferences prefs;

void main() async {
  //Setup all that needs to be ready BEFORE we start the app
  await setupBase();
  print('Ready to rumble');
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future setupBase() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Flame 1.0.0-rc11 related:
  await Flame.device.fullScreen();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);
  //Intl support

  //Init prefs
  prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      debugShowCheckedModeBanner: false,
      title: 'Example',
      initialRoute: '/home',
      routes: {
        //'/': (contex) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/game': (context) => MainGameScreen(
              characteristicVector: {},
            ),
      },
    );
  }
}
