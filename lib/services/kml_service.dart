import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/city.dart';

class KMLService {
  String generateHeatmapKML(City city) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>${city.name} Urban Heat Island</name>
    <Placemark>
      <name>${city.name}</name>
      <Point>
        <coordinates>${city.lon},${city.lat},0</coordinates>
      </Point>
    </Placemark>
    <GroundOverlay>
      <name>${city.name} Heatmap</name>
      <color>660000ff</color>
      <LatLonBox>
        <north>${city.lat + 0.2}</north>
        <south>${city.lat - 0.2}</south>
        <east>${city.lon + 0.2}</east>
        <west>${city.lon - 0.2}</west>
      </LatLonBox>
    </GroundOverlay>
  </Document>
</kml>''';
  }

  Future<String> saveKML(City city) async {
    final kml = generateHeatmapKML(city);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/uhi_${city.name}.kml');
    await file.writeAsString(kml);
    return file.path;
  }
}
