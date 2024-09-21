import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/FirebaseService.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/constants/audio.dart';
import 'package:game_of_trees/firebase_options.dart';
import 'package:game_of_trees/homeScreen.dart';
import 'package:game_of_trees/nodeSelectorScreen.dart';
import 'package:game_of_trees/onboardingScreen.dart';
import 'package:game_of_trees/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainGameScreen.dart';

late SharedPreferences prefs;

void main() async {
  //Setup all that needs to be ready BEFORE we start the app
  await setupBase();
  await setupFirebase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> setupFirebase() async {
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future setupBase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);
  FlameAudio.bgm.play(
    AppAudio.backgroundMusic,
    volume: 0.1,
  );
  FlameAudio.audioCache.loadAll([
    AppAudio.connectNodes,
    AppAudio.levelComplete,
    AppAudio.placingNodes,
  ]);

  //Init prefs
  prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("userID")) {
    GetIt.instance
        .registerLazySingleton<FirebaseService>(() => FirebaseService(prefs));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: flexColorSchemeLight.toTheme,
      debugShowCheckedModeBanner: false,
      title: 'Game of Trees',
      initialRoute: '/home',
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler
            .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: scale),
          child: child!,
        );
      },
      routes: {
        '/home': (context) => HomeScreen(),
        '/help': (context) => OnboardingScreen(
              isPhone: MediaQuery.of(context).size.width < 600,
            ),
        '/game': (context) => MainGameScreen(
              cvAnswer: CVAnswer(isSolved: false, characteristicVector: {}),
            ),
        '/levelSelector': (context) => NodeSelectorScreen(),
      },
    );
  }
}
