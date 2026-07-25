import 'package:flutter/material.dart';

class GeminiFooter extends StatelessWidget {
  const GeminiFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Text(
            'Powered by Gemini',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
