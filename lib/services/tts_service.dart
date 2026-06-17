import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Supported on Android, iOS, macOS, and Web.
class TTSService {
  FlutterTts? _tts;

  static bool get _isSupported =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  TTSService() {
    if (_isSupported) {
      _tts = FlutterTts();
      _tts!.setLanguage('en-IN');
      _tts!.setSpeechRate(0.45);
      _tts!.setVolume(1.0);
    }
  }

  Future<void> speak(String text) async {
    if (_tts == null) return;
    await _tts!.stop();
    await _tts!.speak(text);
  }

  Future<void> stop() async {
    await _tts?.stop();
  }
}
