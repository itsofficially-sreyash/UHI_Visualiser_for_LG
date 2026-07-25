import 'package:flutter/material.dart';

class GetStartedButton extends StatefulWidget {
  final VoidCallback onTap;

  const GetStartedButton({super.key, required this.onTap});

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  
  final double _buttonWidth = 260.0;
  final double _buttonHeight = 60.0;
  final double _circleSize = 48.0;
  final double _padding = 6.0;

  @override
  Widget build(BuildContext context) {
    final double maxDrag = _buttonWidth - _circleSize - (_padding * 2);
    final double textOpacity = (1.0 - (_dragPosition / maxDrag)).clamp(0.0, 1.0);

    return Container(
      width: _buttonWidth,
      height: _buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(_buttonHeight / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: _circleSize / 2),
              child: Text(
                'Slide to Start',
                style: TextStyle(
                  color: Colors.white.withOpacity(textOpacity),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: _dragPosition == 0.0 || _dragPosition == maxDrag 
                ? const Duration(milliseconds: 300) 
                : Duration.zero,
            curve: Curves.easeOutCubic,
            left: _padding + _dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (_isCompleted) return;
                setState(() {
                  _dragPosition += details.delta.dx;
                  if (_dragPosition < 0) _dragPosition = 0;
                  if (_dragPosition > maxDrag) {
                    _dragPosition = maxDrag;
                  }
                });
              },
              onHorizontalDragEnd: (details) {
                if (_isCompleted) return;
                if (_dragPosition > maxDrag * 0.75) {
                  setState(() {
                    _dragPosition = maxDrag;
                    _isCompleted = true;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.onTap();
                  });
                } else {
                  setState(() {
                    _dragPosition = 0.0;
                  });
                }
              },
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
