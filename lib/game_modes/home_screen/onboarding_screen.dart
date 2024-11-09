import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Welcome to The Horn Player's Toolkit!",
      description: "A collection of tools for horn players. ",
      image: "assets/images/logo.png",
    ),
    OnboardingPage(
      title: "Simple Game Mode",
      description:
          "Select your range by dragging the notes up/down, choose your transposition, then get points by playing the displayed note.",
      image: "assets/images/logo.png",
    ),
    OnboardingPage(
      title: "Pong Mode",
      description:
          "Two player game. Select the range and transposition, then each player gets 2 beats to play their note (indicated by green circle). Get a point for hitting the right note on time!",
      image: "assets/images/logo.png",
    ),
    OnboardingPage(
      title: "Community Led",
      description:
          "The Horn Player's Toolkit is a community led project. I'm always looking for ideas for new features or improvements. If you want to join the fun, click the link on the home screen and let me know what you want to add!",
      image: "assets/images/logo.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _numPages,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPageContent(_pages[index]);
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                if (_currentPage == _numPages - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: _onGetStarted,
                      child: const Text("Get Started"),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(page.image, height: 60),
          const SizedBox(height: 20),
          Text(
            page.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Text(
              page.description,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    widget.onFinish();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage(
      {required this.title, required this.description, required this.image});
}
