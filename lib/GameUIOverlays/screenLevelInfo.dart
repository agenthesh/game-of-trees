import 'package:flutter/material.dart';
import 'package:game_of_trees/GameUIOverlays/pageIndicator.dart';

class ScreenLevelInfo extends StatefulWidget {
  const ScreenLevelInfo(
      {Key? key,
      required this.characteristicVectorAnswer,
      required this.onDonePress})
      : super(key: key);
  final Map<String, int> characteristicVectorAnswer;
  final void Function() onDonePress;

  @override
  _ScreenLevelInfoState createState() => _ScreenLevelInfoState();
}

const NumberArray = [
  "Zero",
  "One",
  "Two",
  "Three",
  "Four",
  "Five",
  "Six",
  "Seven",
  "Eight",
  "Nine",
  "Ten",
  "Eleven"
];

class _ScreenLevelInfoState extends State<ScreenLevelInfo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            color: Colors.white,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 25.0),
                child: Column(
                  children: [
                    Text(
                      "Characteristic Vector",
                      style: TextStyle(
                        color: Colors.pink,
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
                              GraphIllustrationCard(
                            numberOfPaths:
                                widget.characteristicVectorAnswer["L$index"]!,
                            length: NumberArray[index],
                          ),
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
                        color: Colors.pink,
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

class GraphIllustrationCard extends StatelessWidget {
  const GraphIllustrationCard(
      {Key? key, required this.numberOfPaths, required this.length})
      : super(key: key);

  final int numberOfPaths;
  final String length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "A Path of Length $length",
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
              fontWeight: FontWeight.w900),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.18,
          child: Image.asset(
            "assets/images/Length$length.png",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox.expand(
              child: Center(
                child: Text("Don't be lazy and make the images please!"),
              ),
            ),
          ),
        ),
        Text(
          numberOfPaths.toString(),
          style: TextStyle(
            color: Colors.pink,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "paths of Length $length in this level",
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
