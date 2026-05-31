import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/city.dart';
import '../providers/city_provider.dart';

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('India UHI Visualizer'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = provider.selectedCity?.name == city.name;
                return ListTile(
                  title: Text(city.name),
                  trailing: const Icon(Icons.thermostat, color: Colors.red),
                  tileColor: isSelected ? Colors.orange.shade50 : null,
                  onTap: () => provider.selectCity(city),
                );
              },
            ),
          ),

          // Bottom panel
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.deepOrange),
            ),

          if (provider.heatStory.isNotEmpty && !provider.isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.selectedCity?.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(provider.heatStory),
                  const SizedBox(height: 8),
                  Text(
                    'KML: ${provider.kmlPath}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: provider.stopNarration,
                    child: const Text('Stop Narration'),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}