import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uhi_visualiser/models/city.dart';
import 'package:uhi_visualiser/services/gemini_service.dart';
import 'package:uhi_visualiser/services/kml_service.dart';
import 'package:uhi_visualiser/services/lg_service.dart';
import 'package:uhi_visualiser/services/tts_service.dart';

class CityProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final KMLService _kml = KMLService();
  final TTSService _tts = TTSService();

  late final LgService lgService;

  City? selectedCity;
  String heatStory = '';
  String kmlPath = '';
  bool isLoading = false;
  bool isConnected = false;
  bool isSpeaking = false;
  String? errorMessage;

  CityProvider(String apiKey) : _gemini = GeminiService(apiKey) {
    lgService = LgService(
      host: '192.168.224.64',
      username: dotenv.env['LG_USERNAME']!,
      password: dotenv.env['LG_PASSWORD']!,
    );
  }

  Future<void> selectCity(City city) async {
    // Stop any ongoing narration when switching cities
    if (isSpeaking) {
      await _tts.stop();
      isSpeaking = false;
    }

    selectedCity = city;
    isLoading = true;
    heatStory = '';
    errorMessage = null;
    notifyListeners();

    // Attempt LG connection
    final connected = await lgService.connect();
    isConnected = connected;
    if (!connected) {
      errorMessage = 'LG rig not reachable — narration only mode.';
    }
    notifyListeners();

    // Generate KML and fetch Gemini story in parallel
    try {
      final results = await Future.wait([
        _kml.saveKML(city),
        _gemini.getCityHeatStory(city.name),
      ]);
      kmlPath = results[0];
      heatStory = results[1];
    } catch (e) {
      errorMessage = 'Failed to load city data. Please try again.';
      heatStory = '';
    }

    isLoading = false;
    notifyListeners();

    // Push KML and fly only if connected
    if (connected && heatStory.isNotEmpty) {
      try {
        final kmlContent = _kml.generateHeatmapKML(city);
        await lgService.sendKML(kmlContent);
        await lgService.flyTo(city.lat, city.lon, 50000);
        debugPrint('KML pushed + FlyTo triggered');
      } catch (e) {
        debugPrint('KML push failed: $e');
      }
    }

    // Start TTS narration
    if (heatStory.isNotEmpty) {
      isSpeaking = true;
      notifyListeners();
      await _tts.speak(heatStory);
      isSpeaking = false;
      notifyListeners();
    }
  }

  Future<void> stopNarration() async {
    await _tts.stop();
    isSpeaking = false;
    notifyListeners();
  }
}