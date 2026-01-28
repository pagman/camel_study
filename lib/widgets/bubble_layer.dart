import 'package:flutter/material.dart';
import '../models/bubble.dart';
import '../theme/app_theme.dart';

class BubbleLayer extends StatelessWidget {
  final List<Bubble> bubbles;

  const BubbleLayer({super.key, required this.bubbles});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: bubbles.map((bubble) {
        return Positioned(
          left: bubble.x - bubble.radius,
          top: bubble.y - bubble.radius,
          child: Container(
            width: bubble.radius * 2,
            height: bubble.radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accentLight.withOpacity(0.4),
                  AppTheme.accent.withOpacity(0.6),
                  AppTheme.accentDark.withOpacity(0.5),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              border: Border.all(
                color: AppTheme.accentMedium.withOpacity(0.8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentMedium.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
