import 'package:flutter/material.dart';

class FooterCredits extends StatelessWidget {
  const FooterCredits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
          children: const [
            TextSpan(text: 'Made with '),
            TextSpan(
              text: '❤️',
              style: TextStyle(color: Colors.red),
            ),
            TextSpan(text: ' by Sreyash'),
          ],
        ),
      ),
    );
  }
}
