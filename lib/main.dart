import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UHI Visualizer',
      home: const CityListScreen(),
    );
  }
}

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  final List<Map<String, dynamic>> cities = const [
    {'name': 'Pune', 'lat': 18.5204, 'lon': 73.8567},
    {'name': 'Delhi', 'lat': 28.6139, 'lon': 77.2090},
    {'name': 'Mumbai', 'lat': 19.0760, 'lon': 72.8777},
  ];

  String generateKML(String cityName, double lat, double lon) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>$cityName Heat Map</name>
    <Placemark>
      <name>$cityName</name>
      <Point>
        <coordinates>$lon,$lat,0</coordinates>
      </Point>
    </Placemark>
    <GroundOverlay>
      <name>$cityName Heatmap</name>
      <color>660000ff</color>
      <LatLonBox>
        <north>${lat + 0.2}</north>
        <south>${lat - 0.2}</south>
        <east>${lon + 0.2}</east>
        <west>${lon - 0.2}</west>
      </LatLonBox>
    </GroundOverlay>
  </Document>
</kml>''';
  }

  Future<void> saveAndOpenKML(BuildContext context, String cityName, double lat, double lon) async {
    final kml = generateKML(cityName, lat, lon);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/uhi_$cityName.kml');
    await file.writeAsString(kml);
    debugPrint('KML saved to: ${file.path}');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('KML saved! Open in Google Earth: ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UHI Visualizer')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            title: Text(city['name']),
            trailing: const Icon(Icons.thermostat, color: Colors.red),
            onTap: () => saveAndOpenKML(
              context,
              city['name'],
              city['lat'],
              city['lon'],
            ),
          );
        },
      ),
    );
  }
}