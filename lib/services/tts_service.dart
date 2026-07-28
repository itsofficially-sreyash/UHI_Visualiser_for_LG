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

  void setStartHandler(VoidCallback handler) {
    _tts?.setStartHandler(handler);
  }

  void setCompletionHandler(VoidCallback handler) {
    _tts?.setCompletionHandler(handler);
  }

  void setCancelHandler(VoidCallback handler) {
    _tts?.setCancelHandler(handler);
  }

  void setPauseHandler(VoidCallback handler) {
    _tts?.setPauseHandler(handler);
  }

  Future<void> speak(String text) async {
    if (_tts == null) return;
    await _tts!.speak(text);
  }

  Future<void> pause() async {
    await _tts?.pause();
  }

  Future<void> stop() async {
    await _tts?.stop();
  }
}
