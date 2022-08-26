import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:game_of_trees/FirebaseService.dart';
import 'package:game_of_trees/TutorialDialog.dart';
import 'package:game_of_trees/primaryButton.dart';
import 'package:game_of_trees/util.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgeDialog extends StatefulWidget {
  const AgeDialog({Key? key}) : super(key: key);

  @override
  State<AgeDialog> createState() => _AgeDialogState();
}

class _AgeDialogState extends State<AgeDialog> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late FixedExtentScrollController _ageScrollController;
  int _selected = 18;

  @override
  void initState() {
    super.initState();

    _ageScrollController = FixedExtentScrollController(initialItem: 18);

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please enter your age!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 150,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: ListWheelScrollView(
                        diameterRatio: 5,
                        onSelectedItemChanged: (x) {
                          setState(() {
                            _selected = x;
                          });
                        },
                        controller: _ageScrollController,
                        children: List.generate(
                          100,
                          (x) => RotatedBox(
                            quarterTurns: 1,
                            child: AnimatedContainer(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              duration: Duration(milliseconds: 400),
                              width: x == _selected ? 80 : 50,
                              height: x == _selected ? 80 : 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: x == _selected ? Colors.yellow : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$x',
                                style: TextStyle(
                                  color: x == _selected ? Colors.grey[900] : Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemExtent: 55.0,
                      ),
                    ),
                  ),
                  PrimaryButton(
                    onPressed: () async {
                      print(_selected);

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      UserCredential usc = await FirebaseAuth.instance.signInAnonymously();

                      if (usc.user != null) {
                        FirebaseDatabase.instance.ref().child(usc.user!.uid).set({"age": _selected});

                        FirebaseAnalytics.instance.setUserId(id: usc.user!.uid);

                        prefs.setString("userID", usc.user!.uid);
                      }

                      GetIt.instance.registerLazySingleton<FirebaseService>(() => FirebaseService(prefs));
                      Navigator.pop(context);
                      showDialog(context: context, builder: (context) => TutorialDialog());
                    },
                    label: "Save!",
                    fontWeight: FontWeight.w700,
                    labelColor: Colors.grey[900]!,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
