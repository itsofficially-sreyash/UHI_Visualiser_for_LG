import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../providers/city_provider.dart';
import '../widgets/narration/animated_waveform.dart';
import '../widgets/narration/playback_button.dart';
import '../widgets/narration/gemini_footer.dart';

class NarrationScreen extends StatefulWidget {
  const NarrationScreen({super.key});

  @override
  State<NarrationScreen> createState() => _NarrationScreenState();
}

class _NarrationScreenState extends State<NarrationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CityProvider>();
    final isPlaying = provider.playbackState == PlaybackState.playing;
    final city = provider.selectedCity;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          provider.stopNarration();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: Color(0xFF111827),
                        ),
                        onPressed: () {
                          provider.stopNarration();
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(),
                      if (city != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              city.name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'India',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                AnimatedWaveform(isPlaying: isPlaying),

                const SizedBox(height: 32),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text(
                        provider.heatStory.isNotEmpty
                            ? provider.heatStory
                            : 'No story available.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF111827),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                const GeminiFooter(),

                if (provider.isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF10B981),
                      ),
                      child: LoadingAnimationWidget.progressiveDots(
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () => provider.simulateMitigation(),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Simulate Mitigation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: PlaybackButton(
                    isPlaying: isPlaying,
                    onTap: () {
                      if (isPlaying) {
                        provider.pauseNarration();
                      } else {
                        provider.playNarration();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
