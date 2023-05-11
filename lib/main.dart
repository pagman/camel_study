import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camel Study technique',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Camel study by Vanya'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();

class _MyHomePageState extends State<MyHomePage> {
  int _session = 0;
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
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                int easy_break = 5;
                int hard_break = 10;
                int study = 0;
                int hard = 90;
                int easy = 25;
                int sessionTime = int.parse(value);
                if (sessionTime >= 130){
                  print("its Valid");
                  while(sessionTime>=25){
                    sessionTime = sessionTime - hard - hard_break - easy - easy_break;
                    rounds ++;
                    breaks =  breaks + 2;
                  }
                  setState(() {
                    _rounds = rounds;
                    _breaks = breaks;
                  });
                }
                else{
                  setState(() {
                    _rounds = 0;
                    _breaks = 0;
                  });

                }

              },
            ),
    ),
            Text(
              (_rounds!=0)?'You have $_rounds rounds and $_breaks breaks ':"",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
