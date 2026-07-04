class LgSettings {
  final String host;
  final int port;
  final String username;
  final String password;
  final int screenCount;

  const LgSettings({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.screenCount,
  });

  factory LgSettings.defaults() => const LgSettings(
    host: '192.168.1.1',
    port: 22,
    username: 'lg',
    password: '',
    screenCount: 3,
  );

  factory LgSettings.fromJson(Map<String, dynamic> json) => LgSettings(
    host: json['host'] as String,
    port: json['port'] as int,
    username: json['username'] as String,
    password: json['password'] as String,
    screenCount: json['screenCount'] as int,
  );

  Map<String, dynamic> toJson() => {
    'host': host,
    'port': port,
    'username': username,
    'password': password,
    'screenCount': screenCount
  };
}
