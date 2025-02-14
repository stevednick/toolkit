import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/localization/localization_provider.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/tools/orientation_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setOrientation(ScreenOrientation.landscapeRight);
  await AssetManager().initialize();
  final localizationProvider = LocalizationProvider();
  await localizationProvider.loadSavedLanguage();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocalizationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: HomeView(),
        home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final hasSeenOnboarding =
                  snapshot.data!.getBool('hasSeenOnboarding') ?? false;
              return hasSeenOnboarding
                  ? HomeView()
                  : OnboardingScreen(onFinish: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeView()),
                      );
                    });
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    ),
  );
}
