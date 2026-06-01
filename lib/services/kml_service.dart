import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import '../models/city.dart';

class KMLService {
  String generateHeatmapKML(City city) {
    final lat = city.lat;
    final lon = city.lon;
    final name = city.name;

    // Generate circle coordinates
    String circle(
      double centerLat,
      double centerLon,
      double radiusDeg,
      int points,
    ) {
      final coords = StringBuffer();
      for (int i = 0; i <= points; i++) {
        final angle = (i * 360 / points) * (3.14159265 / 180);
        final pLat = centerLat + radiusDeg * cos(angle);
        final pLon =
            centerLon +
            (radiusDeg * sin(angle)) / cos(centerLat * 3.14159265 / 180);
        coords.write('$pLon,$pLat,0 ');
      }
      return coords.toString().trim();
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>$name Urban Heat Island</name>

    <Style id="hotZone">
      <PolyStyle><color>cc0000ff</color><outline>0</outline></PolyStyle>
    </Style>
    <Style id="warmZone">
      <PolyStyle><color>aa0066ff</color><outline>0</outline></PolyStyle>
    </Style>
    <Style id="moderateZone">
      <PolyStyle><color>880099ff</color><outline>0</outline></PolyStyle>
    </Style>
    <Style id="coolZone">
      <PolyStyle><color>5500ccaa</color><outline>0</outline></PolyStyle>
    </Style>

    <Placemark>
      <name>$name City Core</name>
      <Point><coordinates>$lon,$lat,0</coordinates></Point>
    </Placemark>

    <!-- Hot core -->
    <Placemark>
      <name>Hot Core</name>
      <styleUrl>#hotZone</styleUrl>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.06, 36)}</coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    </Placemark>

    <!-- Warm ring -->
    <Placemark>
      <name>Warm Zone</name>
      <styleUrl>#warmZone</styleUrl>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.12, 36)}</coordinates>
          </LinearRing>
        </outerBoundaryIs>
        <innerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.06, 36)}</coordinates>
          </LinearRing>
        </innerBoundaryIs>
      </Polygon>
    </Placemark>

    <!-- Moderate ring -->
    <Placemark>
      <name>Moderate Zone</name>
      <styleUrl>#moderateZone</styleUrl>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.19, 36)}</coordinates>
          </LinearRing>
        </outerBoundaryIs>
        <innerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.12, 36)}</coordinates>
          </LinearRing>
        </innerBoundaryIs>
      </Polygon>
    </Placemark>

    <!-- Cool outer ring -->
    <Placemark>
      <name>Cool Zone</name>
      <styleUrl>#coolZone</styleUrl>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.28, 36)}</coordinates>
          </LinearRing>
        </outerBoundaryIs>
        <innerBoundaryIs>
          <LinearRing>
            <coordinates>${circle(lat, lon, 0.19, 36)}</coordinates>
          </LinearRing>
        </innerBoundaryIs>
      </Polygon>
    </Placemark>

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
