import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/GameUIOverlays/pageIndicator.dart';
import 'package:game_of_trees/Providers.dart';

class AnswerScreen extends ConsumerStatefulWidget {
  const AnswerScreen(
      {Key? key,
      required this.onDonePress,
      required this.characteristicVectorAnswer})
      : super(key: key);

  final Map<String, int> characteristicVectorAnswer;

  final void Function() onDonePress;

  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends ConsumerState<AnswerScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> actualCV = ref.watch(cvProvider);
    final bool isCVCorrect = ref.watch(cvCheckProvider);
    final bool isAcyclic = ref.watch(isAcyclicProvider);
    final bool isConnected = ref.watch(isConnectedProvider);
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 25.0),
                child: Column(
                  children: [
                    Text(
                      !isAcyclic
                          ? "Cycles are not allowed!"
                          : !isConnected
                              ? 'Graph needs to connected'
                              : isCVCorrect
                                  ? "Solved!"
                                  : "Try Again!",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: PageView.builder(
                          onPageChanged: (page) => setState(() {
                            _currentIndex = page;
                          }),
                          itemCount:
                              widget.characteristicVectorAnswer.length - 1,
                          itemBuilder: (context, index) =>
                              AnswerIllustrationCard(
                                  userPathCount: actualCV['L$index'] ?? 0,
                                  actualPathCount: widget
                                      .characteristicVectorAnswer["L$index"]!,
                                  pathLength: index),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(
                            widget.characteristicVectorAnswer.length - 1),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => widget.onDonePress(),
                      icon: Icon(
                        Icons.task_alt,
                        size: 40,
                        color: Colors.yellow,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int numberOfPages) {
    List<Widget> list = [];
    for (int i = 0; i < numberOfPages; i++) {
      list.add(i == _currentIndex
          ? PageIndicator(isActive: true)
          : PageIndicator(isActive: false));
    }
    return list;
  }
}

class AnswerIllustrationCard extends StatelessWidget {
  const AnswerIllustrationCard(
      {Key? key,
      required this.userPathCount,
      required this.actualPathCount,
      required this.pathLength})
      : super(key: key);

  final int userPathCount;
  final int actualPathCount;
  final int pathLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userPathCount.toString(),
          style: TextStyle(
            color: userPathCount == actualPathCount
                ? Colors.green
                : Colors.red[900],
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        const Text(
          "Your Paths",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Divider(
            thickness: 2,
          ),
        ),
        Text(
          actualPathCount.toString(),
          style: TextStyle(
            color: Colors.grey[900]!,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Actual Paths of Length $pathLength",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}



// final String CVString = ref.watch(cvProvider);
//     final bool CVCheck = ref.watch(cvCheckProvider);
//     return Positioned.fill(
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Padding(
//           padding:
//               EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
//           child: Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25.0)),
//             color: Colors.white,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.4,
//               padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
//               child: Column(
//                 children: [
//                   Text(
//                     CVCheck ? "You Solved It" : "Please Try Again",
//                     style: TextStyle(
//                       color: Colors.pink,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "Calculated Characteristic Vector is \n\n" +
//                         CVString +
//                         "\n\n Click on Check Graph to check your answer",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Expanded(
//                     child: SizedBox(),
//                   ),
//                   IconButton(
//                     padding: EdgeInsets.zero,
//                     onPressed: () => widget.onDonePress(),
//                     icon: Icon(
//                       Icons.task_alt,
//                       size: 40,
//                       color: Colors.pink,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );