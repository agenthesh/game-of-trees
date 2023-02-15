import 'package:flutter/material.dart';
import 'package:game_of_trees/primaryButton.dart';
import 'package:video_player/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key, required this.isPhone}) : super(key: key);

  final bool isPhone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentPage = 0;
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
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: 14,
            itemBuilder: (_, index) {
              return OnboardingVideos(
                page: index,
                isPhone: widget.isPhone,
              );
            },
          ),
          Positioned(
            bottom: 60,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AnimatedCrossFade(
                  duration: Duration(seconds: 1),
                  crossFadeState: _currentPage == 13
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: SizedBox.shrink(),
                  secondChild: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PrimaryButton(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        width: 120,
                        height: 40,
                        onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut),
                        label: 'Previous',
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      PrimaryButton(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        width: 120,
                        height: 40,
                        onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut),
                        label: 'Next',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: AnimatedCrossFade(
                  duration: Duration(seconds: 1),
                  crossFadeState: _currentPage == 13
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: PrimaryButton(
                    onPressed: () => Navigator.pop(context),
                    label: "Let's start playing!",
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                  secondChild: SmoothPageIndicator(
                    controller: _pageController,
                    count: 13,
                    effect: const JumpingDotEffect(
                      dotWidth: 9,
                      dotHeight: 9,
                      activeDotColor: Color(0xFF696B6D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingVideos extends StatefulWidget {
  const OnboardingVideos({Key? key, required this.page, required this.isPhone})
      : super(key: key);
  final int page;
  final bool isPhone;

  @override
  State<OnboardingVideos> createState() => _OnboardingVideosState();
}

class _OnboardingVideosState extends State<OnboardingVideos> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    String folderName = widget.isPhone ? "phone" : "tab";

    _controller = VideoPlayerController.asset(
        "assets/videos/$folderName/${(widget.page + 1)}.mp4")
      ..initialize().then((value) {
        setState(() {});
        _controller.setPlaybackSpeed(1);

        _controller.play();
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : CircularProgressIndicator(
              color: Colors.yellow,
            ),
    );
  }
}
