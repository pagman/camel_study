import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScheduleList extends StatelessWidget {
  final List<List<int>> scheduleList;
  final bool visible;

  const ScheduleList({
    super.key,
    required this.scheduleList,
    required this.visible,
  });

  String _getSubtitle(List<int> schedule) {
    if (schedule.length == 4) return "Hard Break Easy Break";
    if (schedule.length == 2) return "Easy Break";
    return "Easy";
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Expanded(
        child: ListView.builder(
          itemCount: scheduleList.length,
          itemBuilder: (context, index) {
            return Card(
              color: AppTheme.grayDark.withOpacity(0.7),
              child: ListTile(
                title: Text(
                  scheduleList[index].join(" "),
                  style: TextStyle(color: AppTheme.accentMedium),
                ),
                subtitle: Text(
                  _getSubtitle(scheduleList[index]),
                  style: AppTheme.subtitleStyle,
                ),
                trailing: Icon(Icons.timer, color: AppTheme.accent),
              ),
            );
          },
        ),
      ),
    );
  }
}
