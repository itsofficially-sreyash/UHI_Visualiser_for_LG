import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<double?> getTemperature(double lat, double lon) async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat&longitude=$lon'
      '&current=temperature_2m'
      '&timezone=auto',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    return (data['current']['temperature_2m'] as num).toDouble();
  }

  Future<double> getUHIDelta(double lat, double lon) async {
    final cityTemp = await getTemperature(lat, lon);
    final ruralTemp = await getTemperature(lat + 0.5, lon + 0.5);

    if (cityTemp == null || ruralTemp == null) return 4.0;
    return (cityTemp - ruralTemp).clamp(0.0, 0.12);
  }

  Future<double?> getHistoricalTemperature(double lat, double lon, String year) async {
    // Fetch average temp for May of the given year
    final startDate = '$year-05-01';
    final endDate = '$year-05-31';
    
    final uri = Uri.parse(
      'https://archive-api.open-meteo.com/v1/archive'
      '?latitude=$lat&longitude=$lon'
      '&start_date=$startDate&end_date=$endDate'
      '&daily=temperature_2m_mean'
      '&timezone=auto',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final temps = (data['daily']['temperature_2m_mean'] as List).cast<num?>();
      
      double sum = 0;
      int count = 0;
      for (final temp in temps) {
        if (temp != null) {
          sum += temp.toDouble();
          count++;
        }
      }
      return count > 0 ? sum / count : null;
    } catch (e) {
      return null;
    }
  }
}
