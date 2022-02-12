import 'package:flutter/material.dart';
import 'package:game_of_trees/GameUIOverlays/pageIndicator.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key, required this.onDonePress}) : super(key: key);

  final void Function() onDonePress;

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _currentIndex = 0;

  final List<String> _helpArray = [
    "Tap the screen to add a node to the screen.",
    "Connect the nodes to create a graph that satisfies the characteristic vector.",
    "Click on Check Graph to check your answer"
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
                      "NodeGame Basics",
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
                          itemCount: 2,
                          itemBuilder: (context, index) => HelpIllustrationCard(
                            text: _helpArray[index],
                            index: index,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(2),
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
                    ),
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

class HelpIllustrationCard extends StatelessWidget {
  const HelpIllustrationCard(
      {Key? key, required this.text, required this.index})
      : super(key: key);

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.18,
          child: Image.asset(
            "assets/images/Help$index.gif",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox.expand(
              child: Center(
                child: Text("Don't be lazy and make the images please!"),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 18,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
