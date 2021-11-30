import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/fadeRouteBuilder.dart';
import 'package:game_of_trees/mainGameScreen.dart';
import 'package:rect_getter/rect_getter.dart';

class NodeSelectorScreen extends ConsumerStatefulWidget {
  const NodeSelectorScreen({Key? key}) : super(key: key);

  @override
  _NodeSelectorScreenState createState() => _NodeSelectorScreenState();
}

class _NodeSelectorScreenState extends ConsumerState<NodeSelectorScreen> {
  final GlobalKey<RectGetterState> rectGetterKey =
      RectGetter.createGlobalKey(); //<--Create a key
  Rect? rect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[900],
          body: SafeArea(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            nodeCard(numberOfNodes: index + 5),
                        separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                            ),
                        itemCount: 6),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Select Number of Nodes",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RectGetter(
                    key: rectGetterKey,
                    child: Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 20,
                        crossAxisCount: 1,
                        children: [
                          levelCard(characteristicVector: {
                            "L0": 5,
                            "L1": 4,
                            "L2": 3,
                            "L3": 2,
                            "L4": 1,
                            "L5": 0
                          }),
                          levelCard(characteristicVector: {
                            "L0": 5,
                            "L1": 4,
                            "L2": 4,
                            "L3": 2,
                            "L4": 0,
                            "L5": 0
                          }),
                          levelCard(characteristicVector: {
                            "L0": 5,
                            "L1": 4,
                            "L2": 6,
                            "L3": 0,
                            "L4": 0,
                            "L5": 0
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _ripple(),
      ],
    );
  }

  Widget nodeCard({required int numberOfNodes}) {
    return Card(
      elevation: 25.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.pink,
      child: Container(
        width: 250,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              numberOfNodes.toString(),
              style: TextStyle(
                fontSize: 140,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Nodes",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget levelCard({required Map<String, int> characteristicVector}) {
    return GestureDetector(
      onTap: () => _onLevelTap(characteristicVector: characteristicVector),
      child: Card(
        elevation: 25.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.pink,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: characteristicVector.entries
                  .map((e) => levelInfo(e.key, e.value))
                  .toList()),
        ),
      ),
    );
  }

  Widget levelInfo(String length, int numberOfPaths) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          numberOfPaths.toString(),
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          "x " + formattedLength(length),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  String formattedLength(String unformatted) {
    return unformatted.replaceFirst("L", "Length ");
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

  void _onLevelTap({required Map<String, int> characteristicVector}) async {
    setState(() => rect = RectGetter.getRectFromKey(
        rectGetterKey)); //<-- set rect to be size of fab
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        //<-- on the next frame...
        setState(
          () => rect =
              rect!.inflate(1.3 * MediaQuery.of(context).size.longestSide),
        ); //<-- set rect to be big
        Future.delayed(
          Duration(seconds: 1, milliseconds: 300),
          () => _goToNextPage(characteristicVector: characteristicVector),
        ); //<-- after delay, go to next page
      },
    );
  }

  void _goToNextPage({required Map<String, int> characteristicVector}) {
    Navigator.of(context)
        .push(FadeRouteBuilder(
            page: MainGameScreen(
          characteristicVector: characteristicVector,
        )))
        .then((_) => setState(() => rect = null));
  }
}
