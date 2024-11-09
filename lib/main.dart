import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/tools/orientation_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setOrientation(ScreenOrientation.landscapeOnly);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomeView(),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final hasSeenOnboarding =
                snapshot.data!.getBool('hasSeenOnboarding') ?? false;
            return hasSeenOnboarding
                ? const HomeView()
                : OnboardingScreen(onFinish: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeView()),
                    );
                  });
          }
          return const CircularProgressIndicator();
        },
      ),
    ),
  );
}
