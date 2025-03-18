import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/game_modes/pong/pong_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_view.dart';
import 'package:toolkit/widgets/language_selector.dart';
import 'package:toolkit/widgets/pitch_selector_persistance.dart';
import 'package:toolkit/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatelessWidget {
  
  const HomeView({super.key});

  Widget _buildLocalizationDropdown(BuildContext context) {
    return Positioned(
      left: 70,
      bottom: 70,
      child: LanguageSelector(),
    );
  }

    Widget _buildFrequencyDropdown(BuildContext context) {
    return Positioned(
      left: 70,
      bottom: 112,
      child: PitchSelector()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildLocalizationDropdown(context),
            _buildFrequencyDropdown(context),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Horn Player's Toolkit",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  HomeScreenNavigationButton(
                      route: SimpleGameView(isTimeTrialMode: false,), text: "Simple Game"),
                  const SizedBox(
                    height: 5,
                  ),
                  HomeScreenNavigationButton(
                      route: SimpleGameView(isTimeTrialMode: true,), text: "Time Trial"),
                  const SizedBox(
                    height: 5,
                  ),
                  const HomeScreenNavigationButton(
                      route: PongView(), text: "Pong"),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // HomeScreenNavigationButton(
                    //   route: ExampleScreen(), text: "Stave Icon Test"),
                    //   //route: IncrementalGameView(), text: "Incremental"),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.feedback_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Leave Feedback and Report Bugs",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                onTap: () => launchUrl(
                  Uri.parse('https://horn-toolkit.canny.io/feature-requests'),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(onFinish: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomeView()),
                          );
                        }),
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline)),
            )
          ],
        ));
  }
}
