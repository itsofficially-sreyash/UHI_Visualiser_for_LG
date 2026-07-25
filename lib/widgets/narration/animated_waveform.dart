import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedWaveform extends StatefulWidget {
  final bool isPlaying;

  const AnimatedWaveform({super.key, required this.isPlaying});

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform> with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    if (widget.isPlaying) {
      _morphController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _morphController.forward();
      } else {
        _morphController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 120,
      child: AnimatedBuilder(
        animation: Listenable.merge([_morphController, _waveController]),
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              morphProgress: CurvedAnimation(
                parent: _morphController,
                curve: Curves.easeInOutCubic,
              ).value,
              waveProgress: _waveController.value,
            ),
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double morphProgress;
  final double waveProgress;

  WaveformPainter({required this.morphProgress, required this.waveProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.fill;

    const int barCount = 5;
    final double spacing = size.width / barCount;
    final double maxBarHeight = size.height;
    const double minBarHeight = 8.0;

    final List<double> phases = [0.0, pi / 4, pi / 2, 3 * pi / 4, pi];
    final List<double> speeds = [1.0, 1.5, 1.2, 1.8, 1.3];

    for (int i = 0; i < barCount; i++) {
      final double waveTime = waveProgress * 2 * pi * speeds[i] + phases[i];
      final double sineValue = (sin(waveTime) + 1) / 2;
      
      final double playingHeight = minBarHeight + (maxBarHeight - minBarHeight) * sineValue;
      final double currentHeight = minBarHeight + (playingHeight - minBarHeight) * morphProgress;
      
      final double x = spacing * i + (spacing / 2);
      final double y = size.height / 2;
      
      final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, y), width: 8.0, height: currentHeight),
        const Radius.circular(4.0),
      );
      
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.morphProgress != morphProgress ||
           oldDelegate.waveProgress != waveProgress;
  }
}
