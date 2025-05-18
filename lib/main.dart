import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/home_screen/onboarding_screen.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/providers/language_provider.dart';
import 'package:toolkit/tools/orientation_helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setOrientation(ScreenOrientation.landscapeRight);
  await NoteData.init();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
