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
  int _breaks = 0;


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
            const SizedBox(height: 20,),
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
                onChanged: (value){
                  int rounds = 0;
                  int breaks = 0;
                  int firstHard = 0;
                  int sessionTime = int.parse(value);

                  if (sessionTime >= 130){
                    print("its Valid");
                    while(sessionTime>=130){ //130 120 110 100 90
                      if(rounds ==0 && sessionTime >= 130) {
                        print("mpike");
                        sessionTime =
                            sessionTime - 90 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                        firstHard = 90;
                      }
                      if(rounds ==1 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 80 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds ==2 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 70 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds ==3 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 60 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds >=4 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 50 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                    }
                    print(sessionTime);
                    print(firstHard);
                    print(rounds);
                    setState(() {
                      _rounds = rounds;
                      _breaks = breaks;
                      _firstHard = firstHard;
                    });
                  }
                  else if (sessionTime >= 120 && sessionTime < 130){
                    print("its Valid");
                    while(sessionTime>=120){ //130 120 110 100 90
                      if(rounds ==0 && sessionTime >= 120) {
                        sessionTime =
                            sessionTime - 80 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                        firstHard = 80;
                      }
                      if(rounds ==1 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 70 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds ==2 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 60 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds >=3 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 50 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                    }
                    print(sessionTime);
                    setState(() {
                      _rounds = rounds;
                      _breaks = breaks;
                      _firstHard = firstHard;
                    });
                  }
                  else if (sessionTime >= 110 && sessionTime < 120){
                    print("its Valid");
                    while(sessionTime>=110){ //130 120 110 100 90
                      if(rounds ==0 && sessionTime >= 110) {
                        sessionTime =
                            sessionTime - 70 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                        firstHard = 70;
                      }
                      if(rounds ==1 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 60 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                      if(rounds >=2 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 50 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                    }
                    print(sessionTime);
                    setState(() {
                      _rounds = rounds;
                      _breaks = breaks;
                      _firstHard = firstHard;
                    });
                  }
                  else if (sessionTime >= 100 && sessionTime < 110){
                    print("its Valid");
                    while(sessionTime>=100){ //130 120 110 100 90
                      if(rounds ==0 && sessionTime >= 100) {
                        sessionTime =
                            sessionTime - 60 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                        firstHard = 60;
                      }
                      if(rounds >=1 && sessionTime >= 130) {
                        sessionTime =
                            sessionTime - 50 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                      }
                    }
                    print(sessionTime);
                    setState(() {
                      _rounds = rounds;
                      _breaks = breaks;
                      _firstHard = firstHard;
                    });
                  }
                  else if (sessionTime >= 90 && sessionTime < 100){
                    print("its Valid");
                    while(sessionTime>=90){ //130 120 110 100 90
                      if(rounds >=0 && sessionTime >= 90) {
                        sessionTime =
                            sessionTime - 50 - 10 - 25 - 5;
                        rounds++;
                        breaks = breaks + 2;
                        firstHard = 50;
                      }

                    }
                    print(sessionTime);
                    setState(() {
                      _rounds = rounds;
                      _breaks = breaks;
                      _firstHard = firstHard;
                    });
                  }
                  else{
                    setState(() {
                      _firstHard = 0;
                      _rounds = 0;
                      _breaks = 0;
                    });
                  }

                },
              ),
            ),
            Text(
              (_rounds!=0)?'You have $_rounds rounds and $_breaks breaks and first hard $_firstHard':"",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}