import 'package:flutter/material.dart';
import 'package:uhi_visualiser/services/geocoding_service.dart';
import 'package:uhi_visualiser/services/weather_service.dart';
import '../models/city.dart';
import '../models/lg_settings.dart';
import '../services/gemini_service.dart';
import '../services/kml_service.dart';
import '../services/lg_service.dart';
import '../services/settings_service.dart';
import '../services/tts_service.dart';

enum PlaybackState { idle, playing, paused, completed, stopped }

class CityProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final KMLService _kml = KMLService();
  final TTSService _tts = TTSService();
  final SettingsService _settingsService = SettingsService();
  final GeocodingService _geocoding = GeocodingService();
  final WeatherService _weather = WeatherService();

  LGService? lgService;
  LgSettings? currentSettings;

  City? selectedCity;
  String heatStory = '';
  String kmlPath = '';
  bool isLoading = false;
  bool isConnected = false;
  PlaybackState playbackState = PlaybackState.idle;
  bool get isSpeaking => playbackState == PlaybackState.playing;
  String? errorMessage;
  List<City> searchResults = [];
  bool isSearching = false;
  double currentUHIDelta = 4.0;

  String get getUHIDelta => '+${currentUHIDelta.toStringAsFixed(1)} °C';

  CityProvider(String apiKey) : _gemini = GeminiService(apiKey) {
    _initLgService();
    _initTtsHandlers();
  }

  void _initTtsHandlers() {
    _tts.setStartHandler(() {
      playbackState = PlaybackState.playing;
      notifyListeners();
    });
    _tts.setCompletionHandler(() {
      playbackState = PlaybackState.completed;
      notifyListeners();
    });
    _tts.setCancelHandler(() {
      playbackState = PlaybackState.stopped;
      notifyListeners();
    });
    _tts.setPauseHandler(() {
      playbackState = PlaybackState.paused;
      notifyListeners();
    });
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

    if (playbackState == PlaybackState.playing || playbackState == PlaybackState.paused) {
      await stopNarration();
    }

    selectedCity = city;
    isLoading = true;
    heatStory = '';
    errorMessage = null;
    notifyListeners();

    final connected = await lgService!.connect();
    isConnected = connected;
    if (!connected) {
      errorMessage = 'LG rig not reachable - narration only mode.';
    }
    notifyListeners();

    try {
      final weatherResults = await Future.wait([
        _weather.getUHIDelta(city.lat, city.lon),
        _weather.getHistoricalTemperature(city.lat, city.lon, '1990'),
        _weather.getHistoricalTemperature(city.lat, city.lon, '2023'),
      ]);

      currentUHIDelta = weatherResults[0] as double;
      final pastTemp = weatherResults[1] as double?;
      final currentTemp = weatherResults[2] as double?;

      final results = await Future.wait([
        _gemini.getCityHeatStory(city.name, pastTemp: pastTemp, currentTemp: currentTemp),
        _kml.saveKML(city, uhiDelta: currentUHIDelta),
      ]);

      heatStory = results[0] as String;
      kmlPath = results[1] as String;
    } catch (e) {
      errorMessage = 'Failed to load city data. Please try again.';
      heatStory = '';
    }

    isLoading = false;
    notifyListeners();

    if (heatStory.isNotEmpty) {
      try {
        final kmlContent = _kml.generateHeatmapKML(city);
        await lgService!.sendKML(kmlContent);
        await lgService!.flyTo(city.lat, city.lon, 50000);
        debugPrint('KML pushed + FlyTo triggered');
      } catch (e) {
        debugPrint('KML push failed: $e');
      }
    }

    playbackState = PlaybackState.idle;
    notifyListeners();
  }

  Future<void> playNarration() async {
    if (heatStory.isNotEmpty) {
      await _tts.speak(heatStory);
    }
  }

  Future<void> pauseNarration() async {
    await _tts.pause();
  }

  Future<void> stopNarration() async {
    await _tts.stop();
    playbackState = PlaybackState.stopped;
    notifyListeners();
  }

  Future<void> searchCity(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    isSearching = true;
    notifyListeners();
    searchResults = await _geocoding.searchCity(query);
    isSearching = false;
    notifyListeners();
  }

  void clearSearch() {
    searchResults = [];
    notifyListeners();
  }
}
