import 'dart:io';

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

  CityProvider(String apiKey) : _gemini = GeminiService(apiKey) {
    lgService = LgService(
      host: '10.81.90.240',
      username: dotenv.env['LG_USERNAME']!,
      password: dotenv.env['LG_PASSWORD']!,
    );
  }

  Future<void> selectCity(City city) async {
    selectedCity = city;
    isLoading = true;
    heatStory = '';
    notifyListeners();

    final connected = await lgService.connect();
    print('SSH connected: $connected');

    //generating kml and fetching story in parallel
    final results = await Future.wait([
      _kml.saveKML(city),
      _gemini.getCityHeatStory(city.name),
    ]);

    kmlPath = results[0];
    heatStory = results[1];
    isLoading = false;
    notifyListeners();

    //push kml via ssh
    if (connected) {
      final kmlContent = _kml.generateHeatmapKML(city);
      await lgService.sendKML(kmlContent);
      print('KML pushed via SSH');

      //fly to that city
      await lgService.flyTo(city.lat, city.lon, 50000);
      print('FlyTo triggered');
    }

    await _tts.speak(heatStory);
  }

  Future<void> stopNarration() async {
    await _tts.stop();
  }
}
  // final _privateKey = await File('home/sreyash/.ssh/lg_key').readAsString();