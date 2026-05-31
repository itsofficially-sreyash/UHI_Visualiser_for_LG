import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey;

  GeminiService(this._apiKey);

  Future<String> getCityHeatStory(String cityName) async {
    const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

    final prompt =
        '''
You are a climate narrator for an interactive visualization app.
In exactly 3-4 sentences, narrate the Urban Heat Island situation of $cityName, India.
Include: how much hotter the city core is vs surroundings, main cause, and one human impact.
Keep it conversational, impactful, not technical.
''';

    final response = await http.post(
      Uri.parse('$url?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      debugPrint('Gemini error: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      return 'Unable to fetch heat story for $cityName.';
    }
  }
}
