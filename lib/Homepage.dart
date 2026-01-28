import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_theme.dart';
import 'widgets/bubble_layer.dart';
import 'widgets/timer_display.dart';
import 'widgets/timer_controls.dart';
import 'widgets/schedule_list.dart';
import 'controllers/bubble_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin, BubbleController {
  // Timer state
  int _rounds = 0;
  List<List<int>> scheduleList = [[]];
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  List<String> alarms = [];
  late SharedPreferences sharedPreference;
  bool _isRunning = false;
  bool _isPause = false;
  bool _runOut = false;
  bool _visibleTime = true;
  Timer? _timer;
  TimeOfDay _time = const TimeOfDay(hour: 1, minute: 30);

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
    alarms.clear();
    WidgetsBinding.instance.addObserver(this);
    initBubbleController();
  }

  @override
  void dispose() {
    disposeBubbleController();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadSharedPreferences();
    }
  }

  // Shared Preferences
  Future<void> loadSharedPreferences() async {
    sharedPreference = await SharedPreferences.getInstance();
    List<String> listString = sharedPreference.getStringList('list') ?? [];
    String? scheduleString = sharedPreference.getString('scheduleList');

    if (listString.isEmpty) return;

    // Load the schedule list
    if (scheduleString != null) {
      List<dynamic> decoded = jsonDecode(scheduleString);
      scheduleList = decoded.map((e) => List<int>.from(e)).toList();
      _rounds = scheduleList.length;
    }

    alarms = listString;
    String minutes = alarms[0].split('@')[0];
    DateTime timerStarted = DateTime.parse(alarms[0].split('@')[1]);
    int differenceInTime = DateTime.now().difference(timerStarted).inMinutes;
    String status = alarms[0].split('@')[2];

    if (int.parse(minutes) >= differenceInTime) {
      _minutes = int.parse(minutes) - differenceInTime;
    } else {
      _minutes = 0;
    }

    if (status == 'running') {
      _resumeTimer();
    } else if (status == 'pause') {
      _minutes = int.parse(minutes);
      _pauseTimer();
    }
  }

  // Timer Methods
  void _startTimer() {
    for (int i = 0; i <= scheduleList.length - 1; i++) {
      for (int j = 0; j <= scheduleList[i].length - 1; j++) {
        alarms.add(scheduleList[i][j].toString());
      }
    }

    _minutes = int.parse(alarms.first);
    alarms.insert(0, '${alarms[0]}@${DateTime.now()}@running');
    sharedPreference.setStringList("list", alarms);
    sharedPreference.setString("scheduleList", jsonEncode(scheduleList));
    _seconds = 0;

    setState(() {
      while (alarms[0].contains('@')) {
        alarms.removeAt(0);
      }
      _visibleTime = false;
      _isRunning = true;
    });

    startBubbleAnimation(_hours, _minutes, _seconds, () => _isRunning);
    _startCountdown();
  }

  void _resumeTimer() {
    if (_minutes > 0) {
      alarms.insert(0, '$_minutes@${DateTime.now()}@running');
      sharedPreference.setStringList("list", alarms);
      setState(() {
        while (alarms[0].contains('@')) {
          alarms.removeAt(0);
        }
        alarms.insert(0, '$_minutes@${DateTime.now()}@running');
        sharedPreference.setStringList("list", alarms);
        alarms.removeAt(0);
      });
    }

    setState(() {
      while (alarms[0].contains('@')) {
        alarms.removeAt(0);
      }
      _visibleTime = false;
      _isRunning = true;
    });

    startBubbleAnimation(_hours, _minutes, _seconds, () => _isRunning);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              _isRunning = false;
              _isPause = true;
              _runOut = true;
              stopBubbleAnimation();
              _timer?.cancel();
            }
          }
        }
      });
    });
  }

  void _pauseTimer() {
    while (alarms[0].contains('@')) {
      alarms.removeAt(0);
    }
    alarms.insert(0, '$_minutes@${DateTime.now()}@pause');
    sharedPreference.setStringList("list", alarms);

    setState(() {
      if (alarms[0].contains('@')) {
        alarms.removeAt(0);
      }
      _isRunning = false;
      _isPause = true;
    });
    stopBubbleAnimation();
    _timer?.cancel();
  }

  void _cancelTimer() {
    setState(() {
      _visibleTime = true;
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _isRunning = false;
      _isPause = false;
      _runOut = false;
      _rounds = 0;
      scheduleList = [[]];
    });
    sharedPreference.remove('list');
    sharedPreference.remove('scheduleList');
    clearBubbles();
    _timer?.cancel();
  }

  void _handleStartPause() {
    setState(() {
      _visibleTime = false;
    });

    if (_isRunning) {
      _pauseTimer();
    } else if (_isPause && !_runOut) {
      _resumeTimer();
    } else if (_runOut) {
      alarms.removeAt(0);
      setState(() {
        _minutes = int.parse(alarms[0]);
      });
      _runOut = false;
      _resumeTimer();
    } else {
      alarms.clear();
      _startTimer();
    }
  }

  // Time Selection
  Future<void> _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: AppTheme.timePickerTheme(context),
            child: childWidget!,
          ),
        );
      },
      initialTime: _time,
    );

    if (newTime != null) {
      setState(() {
        _time = newTime;
        _calculateSchedule(newTime);
      });
    }
  }

  void _calculateSchedule(TimeOfDay time) {
    int rounds = 0;
    int flag = 0;
    int hard = 90;
    int sessionTime = time.hour * 60 + time.minute % 60;
    scheduleList.clear();

    while (sessionTime >= 90) {
      if (sessionTime - hard >= 0) {
        sessionTime = sessionTime - hard;
        rounds++;
        scheduleList.add([hard - 40, 10, 25, 5]);
        _rounds = rounds;
      }
      if (hard < 130 && flag == 0) {
        hard = hard + 10;
      } else if (hard == 130) {
        hard = 90;
        flag = 1;
      }
      scheduleList.sort((a, b) => b[0].compareTo(a[0]));
    }

    while (sessionTime <= 90 && sessionTime >= 30) {
      sessionTime = sessionTime - 30;
      rounds++;
      scheduleList.add([25, 5]);
      _rounds = rounds;
    }

    if (sessionTime >= 25 && sessionTime < 30) {
      sessionTime = sessionTime - 25;
      rounds++;
      scheduleList.add([25]);
      _rounds = rounds;
    } else if (sessionTime < 25 && sessionTime > 0) {
      int timeToAdd = (sessionTime / rounds).round();
      for (int i = 0; i <= rounds - 1; i++) {
        if (sessionTime - timeToAdd < 0) {
          break;
        }
        scheduleList[i][0] = scheduleList[i][0] + timeToAdd;
        sessionTime = sessionTime - timeToAdd;
      }
    }
  }

  String get _statusText => (alarms.length % 2 == 0) ? 'Study' : 'Break';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          BubbleLayer(bubbles: bubbles),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TimerDisplay(
                  minutes: _minutes,
                  seconds: _seconds,
                  status: _statusText,
                ),
                Center(
                  child: Text(
                    alarms.join(" "),
                    style: AppTheme.subtitleStyle,
                  ),
                ),
                TimerControls(
                  isRunning: _isRunning,
                  isPause: _isPause,
                  visibleTime: _visibleTime,
                  onStartPause: _handleStartPause,
                  onCancel: _cancelTimer,
                  onSelectTime: _selectTime,
                ),
                const SizedBox(height: 16),
                ScheduleList(
                  scheduleList: scheduleList,
                  visible: _rounds > 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
