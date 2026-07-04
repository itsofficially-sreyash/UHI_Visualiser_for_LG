import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uhi_visualiser/models/lg_settings.dart';

class SettingsService {
  static const _fileName = 'lg_settings.json';

  Future<File> _getFile() async {
    final dir = await getApplicationCacheDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<LgSettings> load() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return LgSettings.defaults();
      final content = await file.readAsString();
      return LgSettings.fromJson(jsonDecode(content));
    } catch (e) {
      debugPrint('Settings load failed: $e');
      return LgSettings.defaults();
    }
  }

  Future<void> save(LgSettings settings) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(settings.toJson()));
    } catch (e) {
      debugPrint('Settings failed to save: $e');
    }
  }
}
