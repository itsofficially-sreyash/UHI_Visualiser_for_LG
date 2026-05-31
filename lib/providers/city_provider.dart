import 'package:flutter/material.dart';
import 'package:uhi_visualiser/models/city.dart';
import 'package:uhi_visualiser/services/gemini_service.dart';
import 'package:uhi_visualiser/services/kml_service.dart';
import 'package:uhi_visualiser/services/tts_service.dart';

class CityProvider extends ChangeNotifier {
  final GeminiService _gemini;
  final KMLService _kml = KMLService();
  final TTSService _tts = TTSService();

  City? selectedCity;
  String heatStory = '';
  String kmlPath = '';
  bool isLoading = false;

  CityProvider(String apiKey) : _gemini = GeminiService(apiKey);

  Future<void> selectCity(City city) async {
    selectedCity = city;
    isLoading = true;
    heatStory = '';
    notifyListeners();

    //generating kml and fetching story in parallel
    final results = await Future.wait([
      _kml.saveKML(city),
      _gemini.getCityHeatStory(city.name),
    ]);

    kmlPath = results[0];
    heatStory = results[1];
    isLoading = false;
    notifyListeners();

    await _tts.speak(heatStory);
  }

  Future<void> stopNarration() async {
    await _tts.stop();
  }
}
