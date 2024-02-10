import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  late DialogAuthCredentials credentials;
  late DialogFlowtter dialogFlowtter;
  List<Map<String, dynamic>> mensaje = [];
  String mensa = "---";

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    super.initState();
  }

  sendMessage(String text) async {
    DetectIntentResponse? response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)));

    //String? textResponse = response.text;

    //print(response.message);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DetectIntentResponse? response = await dialogFlowtter.detectIntent(
              queryInput: QueryInput(text: TextInput(text: 'que hay?')));
          print(response.text);
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyAppp3 extends StatefulWidget {
  const MyAppp3({super.key});

  @override
  State<MyAppp3> createState() => _MyAppp3State();
}

class _MyAppp3State extends State<MyAppp3> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
