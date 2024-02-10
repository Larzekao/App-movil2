import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:prueba3/funciones.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

class Speetext extends StatefulWidget {
  const Speetext({Key? key});

  @override
  State<Speetext> createState() => _SpeetextState();
}

class DialogFlowScreen extends StatefulWidget {
  const DialogFlowScreen({super.key});

  @override
  State<DialogFlowScreen> createState() => _DialogFlowScreenState();
}

class _DialogFlowScreenState extends State<DialogFlowScreen> {
  final messageController = TextEditingController();
  List<Map> messages = [];

  late DialogFlowtter dialogFlowtter;
  List<Map<String, dynamic>> mensaje = [];
  String mensa = "---";

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    super.initState();
  }

  sendMessage(String text) async {
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)));

    String? textResponse = response.text;

    if (textResponse == null) {
      print("nulo");
    } else {
      setState(() {
        mensa = textResponse;
        print(mensa);
      });
      print(textResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatBot'),
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: messageController,
              style: TextStyle(color: Colors.black),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                if (messageController.text.isEmpty) {
                  //print("mensaje vacio");
                } else {
                  setState(() {
                    messages.insert(
                        0, {"data": 1, "message": messageController.text});
                  });

                  //response(messageController.text);
                  sendMessage(messageController.text);
                  //messageController.clear();

                  //print(messages);
                }
              },
              child: Text('TextButton'),
            ),
            Text(mensa),
          ],
        ),
      ),
    );
  }
}

class _SpeetextState extends State<Speetext> {
  SpeechToText _speech = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  bool _isListening = false;
  String _text = 'Presionar para hablar';

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'notListening') {
            setState(() {
              flutterTts.setLanguage('es-ES');
              flutterTts.speak(_text);
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;

            if (val.hasConfidenceRating && val.confidence > 0) {
              //  _confidence = val.confidence;
            }
          }),
          localeId: 'es-ES',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voz a audio'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isListening
                ? const Color.fromARGB(255, 30, 91, 233)
                : Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: _isListening
                    ? const Color.fromARGB(255, 30, 50, 233).withOpacity(0.6)
                    : Colors.transparent,
                spreadRadius: 2.5,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            size: 28,
            color: _isListening ? Colors.white : Colors.black.withOpacity(0.6),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
        child: Text(
          "$_text",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Speech extends StatefulWidget {
  const Speech({super.key});

  @override
  State<Speech> createState() => _SpeechState();
}

class _SpeechState extends State<Speech> {
  //fluter
  ScrollController _controller = ScrollController();

  //instancia de librerias
  SpeechToText _speech = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  //stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Presionar para hablar';
  double _confidence = 1.0;

  //dialogflow
  late DialogFlowtter dialogFlowtter;
  List<Map<String, dynamic>> mensaje = [];
  List<List<String>> Pedidos = [];
  List<String> pedidos1 = [];
  int error = 0;
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
    //_speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) async {
          if (val == 'done') {
            DetectIntentResponse response = await dialogFlowtter.detectIntent(
                queryInput: QueryInput(text: TextInput(text: _text)));
            String? textResponse = response.text;
            String entidades = response.props[1].toString();
            print(entidades.length);

            if (entidades.length != 0) {
              String parametro = extraerObjetoEntreLlaves(entidades);
              print(parametro);
              Map<String, String> objeto = convertirCadenaAObjeto(parametro);
              print(objeto);
              pedidos1 = procesarMapa(objeto);
              print(pedidos1);
              Pedidos.add(pedidos1);
              print(Pedidos);
              print(Pedidos.length);
            }

            if (textResponse == null) {
              textResponse = "error de conexion";
            } else {
              mensaje.add({"boot": textResponse});
            }
            if (textResponse.toLowerCase().contains('cesta')) {
              Pedidos = [];
              pedidos1 = [];
            }
            if (this.error >= 2) {
              mensaje
                  .add({"boot": 'EL menu es capuchino , expreso , americano'});
              flutterTts.setSpeechRate(0.5);
              flutterTts.setLanguage('es-ES');
              flutterTts.speak('EL menu es capuchino , expreso , americano');
              this.error = 0;
            } else {
              if (textResponse.toLowerCase().contains('ups')) {
                if (Pedidos.length >= 2) {
                  mensaje.add({"boot": 'queres terminar tu pedido?'});
                  flutterTts.setSpeechRate(0.5);
                  flutterTts.setLanguage('es-ES');
                  flutterTts
                      .speak('No te entendi ,quieres terminar tu pedido?');
                  this.error++;
                } else {
                  mensaje.add(
                      {"boot": 'EL menu es capuchino , expreso y americano'});
                  flutterTts.setSpeechRate(0.5);
                  flutterTts.setLanguage('es-ES');
                  flutterTts
                      .speak('EL menu es capuchino , expreso y americano');
                  this.error++;
                }
              } else {
                if (textResponse.toLowerCase().contains('llevando')) {
                  mensaje.add({"boot": listToString(Pedidos)});
                  flutterTts.setSpeechRate(0.5);
                  flutterTts.setLanguage('es-ES');
                  String x = listToString(Pedidos);
                  if (x.length > 2) {
                    flutterTts.speak(x);
                  } else {
                    flutterTts.speak('no tienes productos , que desea pedir?');
                  }
                } else {
                  flutterTts.setSpeechRate(0.5);
                  flutterTts.setLanguage('es-ES');
                  flutterTts.speak(textResponse);
                }
              }
            }

            setState(() {
              _isListening = false;
              _controller.jumpTo(_controller.position.maxScrollExtent);
            });
            print(mensaje);
          }
          print('onStatus: $val');
        },
        //onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        //_localeNames = await _speech.locales();
        //print(_localeNames.toString());
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;

                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                }),
            localeId: 'es-Es');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haz tu pedido'),
        //title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        //child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: _isListening ? Colors.pink : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: _isListening ? Colors.pink : Colors.transparent,
                  spreadRadius: 10,
                  blurRadius: 18,
                  offset: Offset(0, 0),
                )
              ]),
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
            shrinkWrap: true,
            //reverse: true,
            controller: _controller,
            itemCount: mensaje.length,
            itemBuilder: (BuildContext, index) {
              return buble(mensaje[index]["boot"].toString());
            },
          )),
          SizedBox(
            height: 90,
          )
        ],
      ),
    );
  }

  Widget buble(String sms) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      //color: Colors.white,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black, width: 1)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
              child: Text(
            sms,
            style: TextStyle(fontSize: 15),
          ))
        ],
      ),
    );
  }
}
