import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uhi_visualiser/constants/env.dart';
import 'providers/city_provider.dart';
import 'screens/city_list_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('No .env file found; continuing without env vars.');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final apiKey = Env.geminiApiKey;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CityProvider(apiKey),
      child: MaterialApp(
        title: 'UHI Visualizer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: const CityListScreen(),
      ),
    );
  }
}