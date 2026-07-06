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
}
