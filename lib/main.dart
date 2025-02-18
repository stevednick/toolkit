import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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

  // Set up logging
  Logger.root.level = Level.ALL; // Adjust this to control logging level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(
    ChangeNotifierProvider(create: (context) => LocalizationProvider(),
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
    )
    
  );
}
