import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final bool isPause;
  final bool visibleTime;
  final VoidCallback onStartPause;
  final VoidCallback onCancel;
  final VoidCallback onSelectTime;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.isPause,
    required this.visibleTime,
    required this.onStartPause,
    required this.onCancel,
    required this.onSelectTime,
  });

  String get _buttonText {
    if (isRunning) return 'Pause';
    if (isPause) return 'Resume';
    return 'Start';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onStartPause,
              style: AppTheme.primaryButtonStyle,
              child: Text(_buttonText),
            ),
            ElevatedButton(
              onPressed: onCancel,
              style: AppTheme.secondaryButtonStyle,
              child: const Text('Cancel'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: visibleTime,
          child: ElevatedButton(
            onPressed: onSelectTime,
            style: AppTheme.tertiaryButtonStyle,
            child: const Text('Select time'),
          ),
        ),
      ],
    );
  }
}
