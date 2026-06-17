import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/city_provider.dart';
import '../theme/app_theme.dart';

/// Bottom sheet that slides up to show the Gemini heat story and TTS controls.
/// Called from CityListScreen via showModalBottomSheet.
class NarrationPanel extends StatelessWidget {
  final CityProvider provider;

  const NarrationPanel({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final city = provider.selectedCity;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City name
                  if (city != null)
                    Text(
                      city.name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                        letterSpacing: 1.8,
                      ),
                    ),

                  const SizedBox(height: 4),
                  Text(
                    'Urban Heat Story',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.divider),
                  const SizedBox(height: 16),

                  // Heat story text
                  Text(
                    provider.heatStory,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurface,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stop narration button (visible only while speaking)
                  if (provider.isSpeaking)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: provider.stopNarration,
                        icon: const Icon(Icons.stop_rounded, size: 18),
                        label: const Text('Stop Narration'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.critical.withValues(alpha: 0.15),
                          foregroundColor: AppColors.critical,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: AppColors.critical.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (!provider.isSpeaking)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              size: 14, color: AppColors.elevated),
                          const SizedBox(width: 8),
                          Text(
                            'Narration complete',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.elevated,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // KML debug path
                  if (provider.kmlPath.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Icon(Icons.code_rounded,
                              size: 13, color: AppColors.onSurfaceMuted),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'KML › ${provider.kmlPath}',
                            style: GoogleFonts.sourceCodePro(
                              fontSize: 10,
                              color: AppColors.onSurfaceMuted,
                              height: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
