import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhi_visualiser/constants/env.dart';
import 'package:uhi_visualiser/screens/home_screen.dart';
import 'package:uhi_visualiser/screens/onboarding_screen.dart';
import 'providers/city_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('No .env file found; continuing without env vars.');
  }

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(MyApp(showOnboarding: !hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  static final apiKey = Env.geminiApiKey;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CityProvider(apiKey),
      child: MaterialApp(
        title: 'UHI Visualizer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
      ),
    );
  }
}