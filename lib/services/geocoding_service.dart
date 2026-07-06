import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uhi_visualiser/models/city.dart';

class GeocodingService {
  Future<List<City>> searchCity(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(query)}&format=json&limit=5',
    );

    final response = await http.get(
      uri,
      headers: {'User-Agent': 'UHIVisualizer/1.0'},
    );

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);
    return data
        .map(
          (e) => City(
            name: e['display_name'].toString().split(',').first,
            lat: double.parse(e['lat']),
            lon: double.parse(e['lon']),
          ),
        )
        .toList();
  }
}
