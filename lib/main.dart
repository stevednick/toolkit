import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/localization/localization_provider.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/providers/language_provider.dart';
import 'package:toolkit/tools/orientation_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: "https://aqgbxuzxmmvtnhsebxzb.supabase.co",
  //   anonKey:
  //       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFxZ2J4dXp4bW12dG5oc2VieHpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA2NTIwMTEsImV4cCI6MjA1NjIyODAxMX0._BgDd3XFdlng_RSMvJ-V982TSgUlsCbDZ2F-QAUQv14",
  // );
  setOrientation(ScreenOrientation.landscapeRight);
  await AssetManager().initialize();

  // Set up logging
  Logger.root.level = Level.ALL; // Adjust this to control logging level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(
    ProviderScope(
    child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(languageProvider.notifier);
    //await localization.loadSavedLanguage();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomeView(),
      locale: Locale(localization.currentLanguage),
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
    );
  }
}
