import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city.dart';
import '../theme/app_theme.dart';

/// Heat severity metadata computed per-city.
class HeatInfo {
  final String deltaLabel;  
  final String severityLabel; 
  final Color color;

  const HeatInfo({
    required this.deltaLabel,
    required this.severityLabel,
    required this.color,
  });
}

/// Returns the heat metadata for a given city name.
HeatInfo heatInfoFor(String cityName) {
  switch (cityName) {
    case 'Delhi':
      return const HeatInfo(deltaLabel: '+6°C', severityLabel: 'Critical', color: AppColors.critical);
    case 'Chennai':
      return const HeatInfo(deltaLabel: '+5°C', severityLabel: 'Severe', color: AppColors.severe);
    case 'Mumbai':
      return const HeatInfo(deltaLabel: '+4°C', severityLabel: 'High', color: AppColors.high);
    case 'Pune':
      return const HeatInfo(deltaLabel: '+3°C', severityLabel: 'Moderate', color: AppColors.moderate);
    case 'Bangalore':
      return const HeatInfo(deltaLabel: '+2°C', severityLabel: 'Elevated', color: AppColors.elevated);
    default:
      return const HeatInfo(deltaLabel: '+?°C', severityLabel: 'Unknown', color: AppColors.onSurfaceMuted);
  }
}

class CityCard extends StatefulWidget {
  final City city;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const CityCard({
    super.key,
    required this.city,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  State<CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<CityCard> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final heat = heatInfoFor(widget.city.name);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.city.name}  •  ${widget.city.lat.toStringAsFixed(4)}°N, '
              '${widget.city.lon.toStringAsFixed(4)}°E',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.surfaceVariant
                : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: widget.isSelected ? heat.color : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Thermometer icon with severity colour
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: heat.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.device_thermostat_rounded,
                        color: heat.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // City name + severity label
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.city.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${heat.severityLabel} heat island',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delta badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: heat.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        heat.deltaLabel,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: heat.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading shimmer overlay (only on selected + loading)
              if (widget.isSelected && widget.isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _ShimmerOverlay(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Subtle animated shimmer overlay shown while data is loading.
class _ShimmerOverlay extends StatefulWidget {
  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        color: AppColors.accent.withValues(alpha: 0.05 + 0.05 * _anim.value),
      ),
    );
  }
}
