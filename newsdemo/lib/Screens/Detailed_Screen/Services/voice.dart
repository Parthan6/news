import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Voice extends StatefulWidget {
  const Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  late FlutterTts flutterTts;
  final String textToRead = "Welcome to the Flutter text-to-speech demo!";

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() {
    flutterTts = FlutterTts();
    flutterTts.setCompletionHandler(() {
      print("Speech completed");
    });
    flutterTts.setErrorHandler((msg) {
      print("Speech error: $msg");
    });
  }

  Future<void> speakText() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);

      var result = await flutterTts.speak(textToRead);
      if (result == 1) {
        print("Speech started");
      } else {
        print("Error starting speech");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Clean up TTS instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: speakText,
      icon: Icon(Icons.volume_up),
    );
  }
}
