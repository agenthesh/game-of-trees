import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_trees/primaryButton.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key, required this.isPhone}) : super(key: key);

  final bool isPhone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;

  bool _isFinishedPlaying = false;

  bool _test = false;

  late Timer _timer;

  @override
  void initState() {
    String assetName = widget.isPhone ? "tutorial-iphone-1" : "tutorial-ipad";

    _timer = Timer(Duration(seconds: 68, milliseconds: 500), () {
      setState(() {
        _test = true;
      });
    });

    _controller = VideoPlayerController.asset("assets/videos/$assetName.mp4")
      ..initialize().then((value) {
        setState(() {});
        _controller.setPlaybackSpeed(2);

        _controller.play();
        setUpListener(_controller);
      });

    super.initState();
  }

  void setUpListener(VideoPlayerController controller) {
    _controller.addListener(() {
      if (_test) {
        _controller.pause();
        setState(() {
          _isFinishedPlaying = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF1E1E1E),
      ),
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
          ),
          Positioned(
            bottom: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AnimatedCrossFade(
                  duration: Duration(seconds: 1),
                  crossFadeState: _isFinishedPlaying ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: PrimaryButton(
                    onPressed: () => Navigator.pop(context),
                    label: "Let's start playing!",
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  secondChild: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
