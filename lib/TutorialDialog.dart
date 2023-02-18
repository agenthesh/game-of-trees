import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:game_of_trees/primaryButton.dart';

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({Key? key}) : super(key: key);

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                    "Would you like to see a tutorial?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/help");
                    },
                    label: "Yes!",
                    fontWeight: FontWeight.w700,
                    labelColor: Colors.grey[900]!,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 255.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(11.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/levelSelector");
                        },
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        highlightColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.3),
                        splashColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.6),
                        child: Center(
                            child: AutoSizeText(
                          "No, thanks",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
