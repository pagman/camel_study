import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/bubble.dart';

/// Mixin that provides bubble animation functionality
mixin BubbleController<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  final List<Bubble> bubbles = [];
  late AnimationController bubbleAnimationController;
  final Random _random = Random();
  int _totalSecondsAtStart = 0;
  Timer? _bubbleSpawnTimer;

  void initBubbleController() {
    bubbleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(updateBubbles);
    bubbleAnimationController.repeat();
  }

  void disposeBubbleController() {
    bubbleAnimationController.dispose();
    _bubbleSpawnTimer?.cancel();
  }

  void startBubbleAnimation(int hours, int minutes, int seconds, bool Function() isRunningCheck) {
    bubbles.clear();
    _totalSecondsAtStart = hours * 3600 + minutes * 60 + seconds;
    if (_totalSecondsAtStart == 0) _totalSecondsAtStart = 1;

    _bubbleSpawnTimer?.cancel();
    _bubbleSpawnTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!isRunningCheck() || !mounted) return;

      int currentSeconds = hours * 3600 + minutes * 60 + seconds;
      double progress = 1.0 - (currentSeconds / _totalSecondsAtStart);
      int targetBubbles = (8 + progress * 42).clamp(8, 50).toInt();

      if (bubbles.length < targetBubbles) {
        spawnBubble();
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && isRunningCheck()) {
        for (int i = 0; i < 5; i++) {
          spawnBubble();
        }
      }
    });
  }

  void stopBubbleAnimation() {
    _bubbleSpawnTimer?.cancel();
  }

  void clearBubbles() {
    setState(() {
      bubbles.clear();
    });
    _bubbleSpawnTimer?.cancel();
  }

  void spawnBubble() {
    final size = MediaQuery.of(context).size;
    double radius = _random.nextDouble() * 20 + 15;

    double x, y;
    int edge = _random.nextInt(4);
    switch (edge) {
      case 0:
        x = _random.nextDouble() * size.width;
        y = -radius;
        break;
      case 1:
        x = _random.nextDouble() * size.width;
        y = size.height + radius;
        break;
      case 2:
        x = -radius;
        y = _random.nextDouble() * size.height;
        break;
      default:
        x = size.width + radius;
        y = _random.nextDouble() * size.height;
        break;
    }

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double angle = atan2(centerY - y, centerX - x);
    double speed = _random.nextDouble() * 1.5 + 0.5;

    setState(() {
      bubbles.add(Bubble(
        x: x,
        y: y,
        vx: cos(angle) * speed + (_random.nextDouble() - 0.5),
        vy: sin(angle) * speed + (_random.nextDouble() - 0.5),
        radius: radius,
      ));
    });
  }

  void updateBubbles() {
    if (bubbles.isEmpty) return;

    final size = MediaQuery.of(context).size;

    setState(() {
      for (var bubble in bubbles) {
        bubble.x += bubble.vx;
        bubble.y += bubble.vy;

        if (bubble.x - bubble.radius < 0) {
          bubble.x = bubble.radius;
          bubble.vx = bubble.vx.abs() * 0.9;
        } else if (bubble.x + bubble.radius > size.width) {
          bubble.x = size.width - bubble.radius;
          bubble.vx = -bubble.vx.abs() * 0.9;
        }

        if (bubble.y - bubble.radius < 0) {
          bubble.y = bubble.radius;
          bubble.vy = bubble.vy.abs() * 0.9;
        } else if (bubble.y + bubble.radius > size.height) {
          bubble.y = size.height - bubble.radius;
          bubble.vy = -bubble.vy.abs() * 0.9;
        }
      }

      for (int i = 0; i < bubbles.length; i++) {
        for (int j = i + 1; j < bubbles.length; j++) {
          _checkCollision(bubbles[i], bubbles[j]);
        }
      }
    });
  }

  void _checkCollision(Bubble a, Bubble b) {
    double dx = b.x - a.x;
    double dy = b.y - a.y;
    double distance = sqrt(dx * dx + dy * dy);
    double minDist = a.radius + b.radius;

    if (distance < minDist && distance > 0) {
      double nx = dx / distance;
      double ny = dy / distance;

      double dvx = a.vx - b.vx;
      double dvy = a.vy - b.vy;
      double dvn = dvx * nx + dvy * ny;

      if (dvn > 0) {
        a.vx -= dvn * nx * 0.9;
        a.vy -= dvn * ny * 0.9;
        b.vx += dvn * nx * 0.9;
        b.vy += dvn * ny * 0.9;

        double overlap = minDist - distance;
        a.x -= overlap * nx * 0.5;
        a.y -= overlap * ny * 0.5;
        b.x += overlap * nx * 0.5;
        b.y += overlap * ny * 0.5;
      }
    }
  }
}
