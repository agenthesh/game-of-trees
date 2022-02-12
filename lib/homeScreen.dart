import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/fadeRouteBuilder.dart';
import 'package:game_of_trees/nodeSelectorScreen.dart';
import 'package:rect_getter/rect_getter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<RectGetterState> rectGetterKey =
      RectGetter.createGlobalKey(); //<--Create a key
  Rect? rect;

  @override
  void initState() {
    ref.read(levelDataProvider).readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1],
          colors: [
            Colors.pink[300]!,
            Colors.pink[400]!,
            Colors.pink[500]!,
            Colors.pink[700]!,
            Colors.pink[500]!,
            Colors.pink[400]!,
            Colors.pink[300]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Transform.rotate(
                      angle: 25.0,
                      child: Text(
                        'Game Of Trees',
                        style: TextStyle(
                          fontSize: 70,
                          fontFamily: "Caveat",
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[300],
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  RectGetter(
                    key: rectGetterKey,
                    child: ElevatedButton(
                      onPressed: _onTap,
                      child: Icon(
                        Icons.play_arrow,
                        size: 125,
                        color: Colors.grey[900],
                      ),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(40.0),
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(40)),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white), // <-- Button color
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.grey[900]; // <-- Splash color
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(
                          Icons.help,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        onPressed: () {},
                        icon: Icon(
                          Icons.copyright,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
    setState(() => rect = RectGetter.getRectFromKey(
        rectGetterKey)); //<-- set rect to be size of fab
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //<-- on the next frame...
      setState(() => rect = rect!.inflate(1.3 *
          MediaQuery.of(context).size.longestSide)); //<-- set rect to be big
      Future.delayed(Duration(seconds: 1, milliseconds: 300),
          _goToNextPage); //<-- after delay, go to next page
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: NodeSelectorScreen()))
        .then((_) => setState(() => rect = null));
  }
}
