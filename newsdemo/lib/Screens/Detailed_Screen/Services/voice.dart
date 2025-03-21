import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Voice extends StatefulWidget {
  final String text;
  Voice({Key? key, required this.text}) : super(key: key);
  //Voice({Key? key}) : super(key: key);

  @override
  State<Voice> createState() => _VoiceState();
}

class _VoiceState extends State<Voice> {
  late FlutterTts flutterTts;

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

  Future<void> speakText(String text) async {
    print("Attempting to speak: $text");

    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    int result = await flutterTts.speak(text);
    print("Speech result: $result");
  }

  @override
  void dispose() {
    flutterTts.stop().then((_) {
      super.dispose();
    });
    // flutterTts.stop(); // Stop TTS before disposing
    // super.dispose(); // Ensure proper cleanup
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        speakText(widget.text.toString());
      },
      icon: const Icon(Icons.volume_up),
    );
  }
}
