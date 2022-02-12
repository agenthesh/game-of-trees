import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Providers.dart';
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
  late PageController _pageController;
  late final levelDataNotifier;
  late int _nodeIndex = 0;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.6);
    levelDataNotifier = ref.read(levelDataProvider);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                        onPageChanged: (int page) => setState(() {
                              _nodeIndex = page;
                            }),
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => nodeCard(
                            numberOfNodes: levelDataNotifier
                                .levelData[index].numberOfNodes),
                        itemCount: levelDataNotifier.levelData.length),
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
                    height: 10,
                  ),
                  RectGetter(
                    key: rectGetterKey,
                    child: Expanded(
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          levelDataNotifier
                              .levelData[_nodeIndex].listOfVectors.length,
                          (index) => levelCard(
                              characteristicVector: levelDataNotifier
                                  .levelData[_nodeIndex].listOfVectors[index],
                              index: index),
                        ),
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
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              numberOfNodes.toString(),
              style: TextStyle(
                fontSize: 90,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Nodes",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget levelCard(
      {required Map<String, int> characteristicVector, required int index}) {
    return GestureDetector(
      onTap: () => _onLevelTap(characteristicVector: characteristicVector),
      child: Card(
        elevation: 10.0,
        shadowColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.pink,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Level ${index.toString()}",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  characteristicVector
                      .toString()
                      .replaceAll("{", "")
                      .replaceAll("}", ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                )
              ],
            )
            // child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: characteristicVector.entries
            //         .map((e) => levelInfo(e.key, e.value))
            //         .toList()),
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
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          "- " + length.toString(),
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
    ref.read(remainingNodeProvider.notifier).state = characteristicVector
            .length -
        1; //this is added here because you cannot change the state of an object during the lifecycle methods of the widget.
    Navigator.of(context)
        .push(
          FadeRouteBuilder(
            page: MainGameScreen(
              characteristicVector: characteristicVector,
            ),
          ),
        )
        .then(
          (_) => setState(() => rect = null),
        );
  }
}
