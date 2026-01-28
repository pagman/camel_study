import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimerDisplay extends StatelessWidget {
  final int minutes;
  final int seconds;
  final String status;

  const TimerDisplay({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: Center(
            child: Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: AppTheme.timerStyle,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              status,
              style: AppTheme.statusStyle,
            ),
          ),
        ),
      ],
    );
  }
}
