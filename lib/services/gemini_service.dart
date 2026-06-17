import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey;

  GeminiService(this._apiKey);

  Future<String> getCityHeatStory(String cityName) async {
    const primaryModel = 'gemini-3.5-flash';
    const fallbackModel = 'gemini-2.5-flash';

    final prompt =
        '''
You are a climate narrator for an interactive visualization app.
In exactly 3-4 sentences, narrate the Urban Heat Island situation of $cityName, India.
Include: how much hotter the city core is vs surroundings, main cause, and one human impact.
Keep it conversational, impactful, not technical.
''';

    final requestBody = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ],
        },
      ],
    });

    // 1. Try with the Primary Model
    String? responseText = await _executeRequestWithRetry(
      primaryModel,
      requestBody,
    );

    // 2. Fall back automatically if Primary returns 429 (Quota Exceeded) or 503 (Overloaded)
    if (responseText == null) {
      debugPrint(
        'Primary model unavailable or quota exhausted. Switching to fallback model...',
      );
      responseText = await _executeRequestWithRetry(fallbackModel, requestBody);
    }

    // 3. Absolute safety net if both free tiers fail
    if (responseText == null) {
      return 'The dense urban core of $cityName is trapping significantly more heat than its greener outskirts. Trapped by heavy concrete and asphalt, this lack of natural cooling drives up temperatures and spikes local energy demands. For residents, this means stifling nights and dangerous daytime heat exposure.';
    }

    return responseText;
  }

  Future<String?> _executeRequestWithRetry(String model, String body) async {
    const maxRetries = 2;
    final url = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/$model:generateContent',
    );

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        if (attempt > 0) {
          final delaySeconds = pow(2, attempt - 1).toInt();
          debugPrint(
            'Retrying model request (Attempt $attempt) in ${delaySeconds}s...',
          );
          await Future.delayed(Duration(seconds: delaySeconds));
        }

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': _apiKey,
          },
          body: body,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['candidates'][0]['content']['parts'][0]['text'];
        }

        if (response.statusCode == 429) {
          debugPrint(
            'Gemini 429 Error: Quota limits reached for this model. Breaking to trigger fallback.',
          );
          break; // Break the retry loop instantly to switch models immediately
        }

        if (response.statusCode == 503) {
          debugPrint(
            'Gemini 503 Error on attempt $attempt: Server experiencing temporary demand spikes.',
          );
          continue; // 503 errors are temporary server hiccups, continue retrying
        }

        debugPrint('Gemini $model unhandled error: ${response.statusCode}');
        break;
      } catch (e) {
        debugPrint('Network connection exception on attempt $attempt: $e');
      }
    }
    return null;
  }
}
