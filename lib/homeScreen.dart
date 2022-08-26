import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/AgeDialog.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/TutorialDialog.dart';
import 'package:game_of_trees/fadeRouteBuilder.dart';
import 'package:game_of_trees/nodeSelectorScreen.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<RectGetterState> rectGetterKey = RectGetter.createGlobalKey(); //<--Create a key
  Rect? rect;

  @override
  void initState() {
    ref.read(levelDataProvider).readFromAppDirectory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.yellow[300]!,
            Colors.yellow[400]!,
            Colors.yellow[500]!,
            Colors.yellow[600]!,
            Colors.yellow[500]!,
            Colors.yellow[400]!,
            Colors.yellow[300]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      right: 20,
                      left: 20,
                    ),
                    child: Image.asset(
                      "assets/images/game-of-trees-logo.png",
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Expanded(
                    child: RectGetter(
                      key: rectGetterKey,
                      child: ElevatedButton(
                        onPressed: _onTap,
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 125,
                            color: Colors.yellow,
                          ),
                        ),
                        style: ButtonStyle(
                          maximumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.2,
                          )),
                          elevation: MaterialStateProperty.all(40.0),
                          shape: MaterialStateProperty.all(CircleBorder()),
                          backgroundColor: MaterialStateProperty.all(Colors.grey[900]), // <-- Button color
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) return Colors.grey[900]; // <-- Splash color
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 50,
                            onPressed: () => Navigator.pushNamed(context, "/help"),
                            icon: Icon(
                              Icons.help,
                              color: Colors.grey[900],
                            ),
                          ),
                          // IconButton(
                          //   iconSize: 50,
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.settings,
                          //     color: Colors.grey[900],
                          //   ),
                          // ),
                          // IconButton(
                          //   iconSize: 50,
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.copyright,
                          //     color: Colors.grey[900],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _ripple(),
        ],
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      //<--replace Positioned with AnimatedPositioned
      duration: Duration(seconds: 1), //<--specify the animation duration
      left: rect!.left,
      right: MediaQuery.of(context).size.width - rect!.right,
      top: rect!.top,
      bottom: MediaQuery.of(context).size.height - rect!.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[900],
        ),
      ),
    );
  }

  void _onTap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userID")) {
      showDialog(context: context, builder: (context) => AgeDialog());
    } else {
      setState(() => rect = RectGetter.getRectFromKey(rectGetterKey)); //<-- set rect to be size of fab
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          //<-- on the next frame...
          setState(() => rect = rect!.inflate(1.3 * MediaQuery.of(context).size.longestSide)); //<-- set rect to be big
          Future.delayed(Duration(seconds: 1, milliseconds: 300), _goToNextPage); //<-- after delay, go to next page
        },
      );
    }
  }

  void _goToNextPage() {
    Navigator.of(context).push(FadeRouteBuilder(page: NodeSelectorScreen())).then((_) => setState(() => rect = null));
  }
}
