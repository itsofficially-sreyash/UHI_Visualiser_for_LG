import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uhi_visualiser/screens/settings_screen.dart';
import '../models/city.dart';
import '../providers/city_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/city_card.dart';
import 'narration_panel.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key});

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  // Tracks whether the narration sheet is currently open
  bool _sheetOpen = false;

  Future<void> _onCityTap(
    BuildContext context,
    CityProvider provider,
    City city,
  ) async {
    // If already loading, ignore
    if (provider.isLoading) return;

    // Close existing sheet if open
    if (_sheetOpen && context.mounted) {
      Navigator.of(context).pop();
      _sheetOpen = false;
    }

    // Kick off load
    await provider.selectCity(city);

    // Show sheet after data arrives (if still mounted)
    if (!mounted) return;
    if (provider.heatStory.isNotEmpty) {
      _sheetOpen = true;
      // ignore: use_build_context_synchronously
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        useRootNavigator: false,
        backgroundColor: Colors.transparent,
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, scrollController) {
            return ListenableBuilder(
              listenable: provider,
              builder: (ctx, _) => NarrationPanel(provider: provider),
            );
          },
        ),
      );
      _sheetOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(provider),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error banner (non-critical — SSH not available)
          if (provider.errorMessage != null && !provider.isLoading)
            _ErrorBanner(message: provider.errorMessage!),

          // Hero header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'India Urban\nHeat Islands',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select a city to explore heat data on LG',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.onSurfaceMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(height: 1, color: AppColors.divider),
          ),
          const SizedBox(height: 12),

          // City cards list
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = provider.selectedCity?.name == city.name;
                return CityCard(
                  city: city,
                  isSelected: isSelected,
                  isLoading: isSelected && provider.isLoading,
                  onTap: () => _onCityTap(context, provider, city),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(CityProvider provider) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: 20,
      title: Row(
        children: [
          // Accent dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'UHI India',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
        // LG Connection status pill
        _LgStatusPill(isConnected: provider.isConnected),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.divider, height: 1),
      ),
    );
  }
}

/// Compact pill showing LG rig connection status.
class _LgStatusPill extends StatelessWidget {
  final bool isConnected;

  const _LgStatusPill({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    final color = isConnected ? AppColors.connected : AppColors.disconnected;
    final label = isConnected ? 'LG Connected' : 'LG Offline';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Non-intrusive error banner shown below the AppBar.
class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppColors.moderate.withValues(alpha: 0.10),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.moderate,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.moderate,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
