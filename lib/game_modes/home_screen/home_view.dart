import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/game_modes/pong/pong_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_view.dart';
import 'package:toolkit/tools/scaled_positioned.dart';
import 'package:toolkit/tools/utils.dart';
import 'package:toolkit/widgets/language_selector.dart';
import 'package:toolkit/widgets/pitch_selector_persistance.dart';
import 'package:toolkit/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final scaleManager = ScaleManager();

  Widget _buildLocalizationDropdown(BuildContext context) {
    return Positioned(
      left: 50 * scaleManager.scaleFactor(),
      bottom: 70 * scaleManager.scaleFactor(),
      child: Transform.scale(
        scale: scaleManager.scaleFactor(),
        child: LanguageSelector(),
      ),
    );
  }

  Widget _buildFrequencyDropdown(BuildContext context) {
    return Positioned(
      left: 50 * scaleManager.scaleFactor(),
      bottom: 112 * scaleManager.scaleFactor(),
      child: Transform.scale(
        scale: scaleManager.scaleFactor(),
        child: PitchSelector(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.of(context).size.width;
      scaleManager.setScreenWidth(width);
    });
    scaleManager.setScreenWidth(MediaQuery.of(context).size.width);
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
                  SizedBox(
                    height: 10 * scaleManager.scaleFactor(),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 80 * scaleManager.scaleFactor(),
                      width: 80 * scaleManager.scaleFactor(),
                    ),
                  ),
                  SizedBox(
                    height: 30 * scaleManager.scaleFactor(),
                  ),
                  Transform.scale(
                    scale: scaleManager.scaleFactor(),
                    child: HomeScreenNavigationButton(
                        route: SimpleGameView(), text: "Simple Game"),
                  ),
                  SizedBox(
                    height: 5 * scaleManager.scaleFactor(),
                  ),
                  Transform.scale(
                    scale: scaleManager.scaleFactor(),
                    child: HomeScreenNavigationButton(
                        route: PongView(), text: "Pong"),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // const HomeScreenNavigationButton(
                  //     route: IncrementalGameView(), text: "Incremental"),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: InkWell(
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.all(16.0),
            //           child: Icon(
            //             Icons.feedback_outlined,
            //             color: Colors.blue,
            //           ),
            //         ),
            //         Text(
            //           "Leave Feedback and Report Bugs",
            //           style: TextStyle(
            //             color: Colors.blue,
            //           ),
            //         ),
            //       ],
            //     ),
            //     onTap: () => launchUrl(
            //       Uri.parse('https://horn-toolkit.canny.io/feature-requests'),
            //     ),
            //   ),
            // ),
            ScaledPositioned(
              bottom: 30,
              right: 30,
              scaleFactor: scaleManager.scaleFactor(),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnboardingScreen(onFinish: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeView()),
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
