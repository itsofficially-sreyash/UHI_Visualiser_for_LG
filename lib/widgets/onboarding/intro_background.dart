import 'package:flutter/material.dart';

class IntroBackground extends StatefulWidget {
  const IntroBackground({super.key});

  @override
  State<IntroBackground> createState() => _IntroBackgroundState();
}

class _IntroBackgroundState extends State<IntroBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1), 
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/intro_bg.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
