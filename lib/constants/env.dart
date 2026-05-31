import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
