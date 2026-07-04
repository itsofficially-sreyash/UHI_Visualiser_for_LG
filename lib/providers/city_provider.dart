import 'package:flutter/material.dart';
import '../models/city.dart';
import '../models/lg_settings.dart';
import '../services/gemini_service.dart';
import '../services/kml_service.dart';
import '../services/lg_service.dart';
import '../services/settings_service.dart';
import '../services/tts_service.dart';

class CityProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final KMLService _kml = KMLService();
  final TTSService _tts = TTSService();
  final SettingsService _settingsService = SettingsService();

  LGService? lgService;
  LgSettings? currentSettings;

  City? selectedCity;
  String heatStory = '';
  String kmlPath = '';
  bool isLoading = false;
  bool isConnected = false;
  bool isSpeaking = false;
  String? errorMessage;

  CityProvider(String apiKey) : _gemini = GeminiService(apiKey) {
    _initLgService();
  }

  Future<void> _initLgService() async {
    final settings = await _settingsService.load();
    currentSettings = settings;
    lgService = LGService(
      host: settings.host,
      port: settings.port,
      username: settings.username,
      password: settings.password,
      screenCount: settings.screenCount,
    );
    notifyListeners();
  }

  Future<void> reloadLgService() async {
    await _initLgService();
  }

  Future<void> selectCity(City city) async {
    if (lgService == null) return;

    if (isSpeaking) {
      await _tts.stop();
      isSpeaking = false;
    }

    selectedCity = city;
    isLoading = true;
    heatStory = '';
    errorMessage = null;
    notifyListeners();

    final connected = await lgService!.connect();
    isConnected = connected;
    if (!connected) {
      errorMessage = 'LG rig not reachable — narration only mode.';
    }
    notifyListeners();

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

    if (connected && heatStory.isNotEmpty) {
      try {
        final kmlContent = _kml.generateHeatmapKML(city);
        await lgService!.sendKML(kmlContent);
        await lgService!.flyTo(city.lat, city.lon, 50000);
        debugPrint('KML pushed + FlyTo triggered');
      } catch (e) {
        debugPrint('KML push failed: $e');
      }
    }

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