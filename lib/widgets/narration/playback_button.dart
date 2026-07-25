import 'package:flutter/material.dart';

class PlaybackButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const PlaybackButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  State<PlaybackButton> createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButton> with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  
  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.isPlaying) {
      _iconController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PlaybackButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF333333),
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      child: InkWell(
        onTap: widget.onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 76,
          height: 76,
          alignment: Alignment.center,
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _iconController,
            color: Colors.white,
            size: 38,
          ),
        ),
      ),
    );
  }
}
