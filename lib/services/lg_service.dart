import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/widgets.dart';

class LgService {
  SSHClient? _client;

  final String host;
  final int port;
  final String username;
  // final String privateKey;
  final String password;
  final int screenCount;

  LgService({
    required this.host,
    this.port = 22,
    required this.username,
    // required this.privateKey,
    required this.password,
    this.screenCount = 1, //1 for testing, update for testing
  });

  //connect to lg master or localhost
  Future<bool> connect() async {
    try {
      final socket = await SSHSocket.connect(host, port);
      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );
      final result = await _client!.run('echo connected');
      print('SSH auth test: ${String.fromCharCodes(result)}');
      return true;
    } catch (e) {
      debugPrint('SSH connection failed: $e');
      _client = null;
      return false;
    }
  }

  //push kml content to master
  Future<void> sendKML(String kmlContent) async {
    if (_client == null) return;
    try {
      //write kml to lg master path
      final escaped = kmlContent.replaceAll("'", "'\\''");
      await _client!.run("echo '$escaped' > /var/www/html/kml/master.kml");
    } catch (e) {
      print('KML push failed: $e');
    }
  }

  //fly camera to coordinates
  Future<void> flyTo(double lat, double lon, double altitude) async {
    if (_client == null) return;

    try {
      final flyToKml =
          '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <Placemark>
      <LookAt>
        <longitude>$lon</longitude>
        <latitude>$lat</latitude>
        <altitude>0</altitude>
        <range>$altitude</range>
        <tilt>0</tilt>
        <heading>0</heading>
        <altitudeMode>relativeToGround</altitudeMode>
      </LookAt>
    </Placemark>
  </Document>
</kml>''';

      final escaped = flyToKml.replaceAll("'", "'\\''");
      await _client!.run("echo '$escaped' > /var/www/html/kml/flyto.kml");
      print('FlyTo KML pushed');
    } catch (e) {
      print('FlyTo failed: $e');
    }
  }

  Future<void> clearKML() async {
    if (_client == null) return;
    try {
      await _client!.run("echo '' > /var/www/html/kml/master.kml");
    } catch (e) {
      print('Clear failed: $e');
    }
  }

  void disconnect() {
    _client?.close();
    _client = null;
  }

  bool get isConnected => _client != null;
}
