class City {
  final String name;
  final double lat;
  final double lon;

  const City({required this.name, required this.lat, required this.lon});
}

const List<City> cities = [
  City(name: 'Pune', lat: 18.5204, lon: 73.8567),
  City(name: 'Delhi', lat: 28.6139, lon: 77.2090),
  City(name: 'Mumbai', lat: 19.0760, lon: 72.8777),
  City(name: 'Bangalore', lat: 12.9716, lon: 77.5946),
  City(name: 'Chennai', lat: 13.0827, lon: 80.2707),
];
