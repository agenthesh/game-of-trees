import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/node_card.dart';
import 'package:game_of_trees/node_level_list.dart';
import 'package:game_of_trees/state/levels/level_data_notifier.dart';
import 'package:game_of_trees/theme.dart';
import 'package:rect_getter/rect_getter.dart';

final GlobalKey<RectGetterState> rectGetterKey =
    RectGetter.createGlobalKey(); //<--Create a key

class NodeSelectorScreen extends ConsumerStatefulWidget {
  const NodeSelectorScreen({Key? key}) : super(key: key);

  @override
  _NodeSelectorScreenState createState() => _NodeSelectorScreenState();
}

class _NodeSelectorScreenState extends ConsumerState<NodeSelectorScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.6);
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
    final levelState = ref.watch(levelDataNotifierProvider);
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
                      onPageChanged: (int page) {
                        final numberOfNodes =
                            levelState.levelData[page].numberOfNodes;
                        ref
                            .read(levelDataNotifierProvider.notifier)
                            .setCurrentNumberOfNodes(
                                numberOfNodes: numberOfNodes);
                      },
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: levelState.levelData.length,
                      itemBuilder: (context, index) => NodeCard(
                        numberOfNodes:
                            levelState.levelData[index].numberOfNodes,
                      ),
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
                      child: NodeLevelList(),
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

  String formattedLength(String unformatted) {
    return unformatted.replaceFirst("L", "Length ");
  }

  Widget _ripple() {
    return Consumer(
      builder: (context, ref, child) {
        final rect =
            ref.watch(levelDataNotifierProvider.select((value) => value.rect));
        if (rect == null)
          return Container();
        else
          return AnimatedPositioned(
            //<--replace Positioned with AnimatedPositioned
            duration: Duration(seconds: 1), //<--specify the animation duration
            left: rect.left,
            right: MediaQuery.of(context).size.width - rect.right,
            top: rect.top,
            bottom: MediaQuery.of(context).size.height - rect.bottom,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[900],
              ),
            ),
          );
      },
    );
  }
}
