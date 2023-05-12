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
  bool _runOut = false;
  Timer? _timer;
  int _value = 300;
  String _status = 'idle';
  Color _statusColor = Colors.amber;
  TimeOfDay _time = TimeOfDay(hour: 1, minute: 30);

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
    setState(() {
      print(listString);
      alarms = listString;
      String minutes = alarms[0].split('@')[0];
      DateTime timerStarted = DateTime.parse(alarms[0].split('@')[1]);
      print(timerStarted);
      print(DateTime.now());
      int differenceIntime = DateTime.now().difference(timerStarted).inMinutes;
      print(differenceIntime);
      if(int.parse(minutes)>=differenceIntime){
        _minutes = int.parse(minutes)-differenceIntime;
      }
      else{
        _minutes = 0;
      }
      _resumeTimer();
      alarms.removeAt(0);
    });
  }

  void _startTimer() {
    for (int i = 0; i <= scheduleList.length - 1; i++) {
      for (int j = 0; j <= 3; j++) {
        alarms.add(scheduleList[i][j].toString());
      }
    }

    _minutes = int.parse(alarms.first);
    alarms[0] = alarms[0]+'@'+DateTime.now().toString();
    sharedPreference.setStringList("list",alarms);
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
              print("run out1");
              _isRunning = false;
              _isPause = true;
              _runOut = true;
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
              print("run out2");
              _isRunning = false;
              _isPause = true;
              _runOut = true;
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
      _isPause = false;
      _runOut = false;
    });
    _timer?.cancel();
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      builder: (context, childWidget) {

        return
          MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child:
          Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xffA0D8B3), // <-- SEE HERE
              onPrimary: Color(0xffA2A378), // <-- SEE HERE
              onSurface: Color(0xff83764F), // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(0xffA2A378), // button text color
              ),
            ),
          ),

          child: childWidget!,
        ));
      },
      initialTime: _time,
    );
    if (newTime != null) {
      print(newTime.hour*60+newTime.minute%60);
      setState(() {
        _time = newTime;
        _value = newTime.hour*60+newTime.minute%60;
        //print(_value);
        int rounds = 0;
        int flag = 0;
        int hard = 130;
        int sessionTime = newTime.hour*60+newTime.minute%60;
        scheduleList.clear();
        while (sessionTime >= 90) {
          if (sessionTime - hard >= 0) {
            print(hard);
            sessionTime = sessionTime - hard;
            rounds++;
            setState(() {
              scheduleList.add([hard-40,10,25,5]);
              //scheduleList.add([0,0,0,0]);
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
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      appBar: AppBar(
        backgroundColor: Color(0xff83764F),
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
                      fontSize: 60, fontWeight: FontWeight.bold,color: Color(0xffA0D8B3)),

                ),
              ),
            ),
            Center(
              child:
              Text(alarms.join(" "),
                  style: TextStyle(color: Color(0xffA0D8B3)),),
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
                    else if(_isPause && !_runOut){
                      _resumeTimer();
                    }
                    else if(_runOut && _runOut){
                      print("on resume run out button");
                      alarms.removeAt(0);
                      setState(() {
                        _minutes = int.parse(alarms[0]);
                      });
                      _runOut = false;
                      _resumeTimer();
                    }
                      else {
                      alarms.clear();
                      _startTimer();
                    }
                  },
                  style:
                  ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffA0D8B3),
                      fixedSize: const Size(150, 40)),
                  child: _isRunning? const Text('Pause') :(!_isRunning && _isPause)? const Text('Resume'):const Text('Start'),
                ),
                // The cancel button
                ElevatedButton(
                  onPressed: _cancelTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffA2A378),
                      fixedSize: const Size(150, 40)),
                  child: const Text('Cancel'),
                ),
              ],
            ),
            Center(
              child:
              ElevatedButton(
                onPressed: _selectTime,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff83764F),
                    fixedSize: const Size(150, 40)),
                child: const Text('Select time'),
              ),
            ),

            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SliderTheme(
            //       data: SliderTheme.of(context).copyWith(
            //         trackHeight: 10.0,
            //         trackShape: RoundedRectSliderTrackShape(),
            //         activeTrackColor: Colors.purple.shade800,
            //         inactiveTrackColor: Colors.purple.shade100,
            //         thumbShape: RoundSliderThumbShape(
            //           enabledThumbRadius: 14.0,
            //           pressedElevation: 8.0,
            //         ),
            //         thumbColor: Colors.pinkAccent,
            //         overlayColor: Colors.pink.withOpacity(0.2),
            //         overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
            //         tickMarkShape: RoundSliderTickMarkShape(),
            //         activeTickMarkColor: Colors.pinkAccent,
            //         inactiveTickMarkColor: Colors.white,
            //         valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            //         valueIndicatorColor: Colors.black,
            //         valueIndicatorTextStyle: TextStyle(
            //           color: Colors.white,
            //           fontSize: 20.0,
            //         ),
            //       ),
            //       child: Slider(
            //         min: 90,
            //         max: 1000,
            //         value: _value.toDouble(),
            //         divisions: 910,
            //         label: '${_value.round()}',
            //         onChanged: (value) {
            //           setState(() {
            //             _value = value.round();
            //             //print(_value);
            //             int rounds = 0;
            //             int flag = 0;
            //             int hard = 130;
            //             int sessionTime = value.round();
            //             scheduleList.clear();
            //             while (sessionTime >= 90) {
            //               if (sessionTime - hard >= 0) {
            //                 print(hard);
            //                 sessionTime = sessionTime - hard;
            //                 rounds++;
            //                 setState(() {
            //                   scheduleList.add([hard-40,10,25,5]);
            //                   //scheduleList.add([0,0,0,0]);
            //                   _rounds = rounds;
            //                 });
            //
            //               }
            //               print("Session time left: $sessionTime");
            //               if (hard > 90) {
            //                 hard = hard - 10;
            //                 print(hard);
            //               }
            //
            //             }
            //             print(scheduleList);
            //
            //           });
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            //   child: TextFormField(
            //     keyboardType: TextInputType.number,
            //     decoration: const InputDecoration(
            //       border: OutlineInputBorder(),
            //       hintText: 'Enter session time',
            //     ),
            //     // The validator receives the text that the user has entered.
            //     validator: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'Please enter some text';
            //       }
            //       return null;
            //     },
            //     onChanged: (value) {
            //       int rounds = 0;
            //       int flag = 0;
            //       int hard = 130;
            //       int sessionTime = int.parse(value);
            //       scheduleList.clear();
            //       while (sessionTime >= 90) {
            //         if (sessionTime - hard >= 0) {
            //           print(hard);
            //           sessionTime = sessionTime - hard;
            //           rounds++;
            //           setState(() {
            //             scheduleList.add([hard-40,10,25,5]);
            //             //scheduleList.add([0,0,0,0]);
            //             _rounds = rounds;
            //           });
            //
            //         }
            //         print("Session time left: $sessionTime");
            //         if (hard > 90) {
            //           hard = hard - 10;
            //           print(hard);
            //         }
            //
            //       }
            //       print(scheduleList);
            //
            //     },
            //   ),
            // ),
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
