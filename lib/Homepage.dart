import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage> {
  int _firstHard = 0;
  int _rounds = 0;
  int _timeLeft = 0;
  List<List<int>> scheduleList = [[]];


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
            Text(
              'Timer Goes Here!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 20,
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
