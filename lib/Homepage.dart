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
                  int sessionTime1 = int.parse(value);

                  while(sessionTime > 30){
                    

                  }
                  // else{
                  //   setState(() {
                  //     _firstHard = 0;
                  //     _rounds = 0;
                  //     _breaks = 0;
                  //   });
                  // }

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