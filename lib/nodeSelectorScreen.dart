import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/fadeRouteBuilder.dart';
import 'package:game_of_trees/mainGameScreen.dart';
import 'package:game_of_trees/services.dart';
import 'package:game_of_trees/theme.dart';
import 'package:game_of_trees/util.dart';
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
          appBar: AppBar(
            backgroundColor: flexColorSchemeLight.secondary,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Node Select",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/help"),
                  child: Icon(
                    Icons.help,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey[900],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      onPageChanged: (int page) => setState(() {
                        _nodeIndex = page;
                      }),
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => nodeCard(
                          numberOfNodes:
                              levelDataNotifier.levelData[index].numberOfNodes),
                      itemCount: levelDataNotifier.levelData.length,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Level Select",
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
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        children: List.generate(
                          levelDataNotifier
                              .levelData[_nodeIndex].listOfVectors.length,
                          (index) => levelCard(
                              cvAnswer: levelDataNotifier
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
      color: Colors.yellow,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              numberOfNodes.toString(),
              style: TextStyle(
                fontSize: 70,
                color: Colors.grey[900],
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Nodes",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[900],
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget levelCard({required CVAnswer cvAnswer, required int index}) {
    return GestureDetector(
      onTap: () => _onLevelTap(cvAnswer: cvAnswer),
      child: Card(
        elevation: 10.0,
        shadowColor: cvAnswer.isSolved ? Colors.green[100] : Colors.yellow[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: cvAnswer.isSolved ? Colors.green : Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Level ${(index + 1).toString()}",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w900,
                ),
              ),
              AutoSizeText(
                formatCharacteristicVector(cvAnswer.characteristicVector),
                textAlign: TextAlign.center,
                maxLines: 4,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
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

  void _onLevelTap({required CVAnswer cvAnswer}) async {
    firebaseService.startNewLevelEvent(
        numberOfNodes: levelDataNotifier
            .levelData[_pageController.page!.toInt()].numberOfNodes,
        characteristicVector: cvAnswer.characteristicVector);

    setState(() => rect = RectGetter.getRectFromKey(
        rectGetterKey)); //<-- set rect to be size of fab
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //<-- on the next frame...
        setState(
          () => rect =
              rect!.inflate(1.3 * MediaQuery.of(context).size.longestSide),
        ); //<-- set rect to be big
        Future.delayed(
          Duration(seconds: 1, milliseconds: 300),
          () => _goToNextPage(cvAnswer: cvAnswer),
        ); //<-- after delay, go to next page
      },
    );
  }

  void _goToNextPage({required CVAnswer cvAnswer}) {
    ref.read(remainingNodeProvider.notifier).state = cvAnswer
            .characteristicVector.length -
        1; //this is added here because you cannot change the state of an object during the lifecycle methods of the widget.
    Navigator.of(context)
        .push(
          FadeRouteBuilder(
            page: MainGameScreen(
              cvAnswer: cvAnswer,
            ),
          ),
        )
        .then(
          (_) => setState(() => rect = null),
        );
  }
}
