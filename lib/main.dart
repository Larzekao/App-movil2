import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:prueba3/audio.dart';
import 'package:prueba3/componentes..dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
//import 'package:dialogflow_flutter/googleAuth.dart';
//import 'package:dialogflow_flutter/language.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //  home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Speech(), //Speetext
    );
  }
}
