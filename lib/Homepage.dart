import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage> {
  int _rounds = 0;
  List<List<int>> scheduleList = [[]];
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  List<String> alarms = [];
  late SharedPreferences sharedPreference;
  bool _isRunning = false;
  bool _isPause = false;
  Timer? _timer;

  @override
  void initState() {
    loadSharedPreferences();
    alarms.clear();
    super.initState();
  }

  loadSharedPreferences() async {
    sharedPreference = await SharedPreferences.getInstance();
    List<String> listString = sharedPreference.getStringList('list')??[];
    print("loaded");
  }

  void _startTimer() {
    for (int i = 0; i <= scheduleList.length - 1; i++) {
      for (int j = 0; j <= 3; j++) {
        alarms.add(scheduleList[i][j].toString());
      }
    }

    sharedPreference.setStringList("list",alarms);
    _minutes = int.parse(alarms.first);
    _seconds = 0;
    alarms.removeAt(0);

    setState(() {
      _isRunning = true;
    });
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
              print("run out");
              _isRunning = false;
              _timer?.cancel();
            }
          }
        }
      });
    });
  }
  void _resumeTimer() {
    setState(() {
      _isRunning = true;
    });
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
              print("run out");
              _isRunning = false;
              _timer?.cancel();
            }
          }
        }
      });
    });
  }

  // This function will be called when the user presses the pause button
  // Pause the timer
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _isPause = true;
    });
    _timer?.cancel();
  }

  // This function will be called when the user presses the cancel button
  // Cancel the timer
  void _cancelTimer() {
    setState(() {
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
      _isRunning = false;
      _isPause = false;
    });
    _timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Center(
                child: Text(
                  '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.bold),

                ),
              ),
            ),
            Center(
              child:
              Text(alarms.join(" ")),
            ),
            // The 3 sliders to set hours, minutes and seconds

            // The start/pause and cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // The start/pause button
                // The text on the button changes based on the state (_isRunning)
                ElevatedButton(
                  onPressed: () {
                    if (_isRunning) {
                      _pauseTimer();
                    }
                    else if(_isPause){
                      _resumeTimer();
                    }
                      else {
                      alarms.clear();
                      _startTimer();
                    }
                  },
                  style:
                  ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
                  child: _isRunning? const Text('Pause') :(!_isRunning && _isPause)? const Text('Resume'):const Text('Start'),
                ),
                // The cancel button
                ElevatedButton(
                  onPressed: _cancelTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(150, 40)),
                  child: const Text('Cancel'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter session time',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onChanged: (value) {
                  int rounds = 0;
                  int flag = 0;
                  int hard = 130;
                  int sessionTime = int.parse(value);
                  scheduleList.clear();
                  while (sessionTime >= 90) {
                    if (sessionTime - hard >= 0) {
                      print(hard);
                      sessionTime = sessionTime - hard;
                      rounds++;
                      setState(() {
                        scheduleList.add([hard-40,10,25,5]);
                        _rounds = rounds;
                      });

                    }
                    print("Session time left: $sessionTime");
                    if (hard > 90) {
                      hard = hard - 10;
                      print(hard);
                    }

                  }
                  print(scheduleList);

                },
              ),
            ),
        Visibility(
          visible:(_rounds>0)?true:false,
          child: Expanded(
            child: ListView.builder(
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                          title: Text("${scheduleList[index][0]} "+ "${scheduleList[index][1]} "+"${scheduleList[index][2]} "+"${scheduleList[index][3]}"),
                          subtitle: Text("Hard Break Easy Break"),
                          trailing: Icon(Icons.timer)));
                }),
          ),
        ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
