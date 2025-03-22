import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NewsPodcastPage extends StatefulWidget {
  final String newsContent;
  final String languageCode;

  const NewsPodcastPage({
    Key? key,
    required this.newsContent,
    this.languageCode = 'en-US',
  }) : super(key: key);

  @override
  State<NewsPodcastPage> createState() => _NewsPodcastPageState();
}

class _NewsPodcastPageState extends State<NewsPodcastPage> {
  final FlutterTts flutterTts = FlutterTts();
  final ItemScrollController _scrollController = ItemScrollController();

  List<String> sentences = [];
  int currentIndex = 0;
  bool isPlaying = false;
  double playbackSpeed = 0.5;

  @override
  void initState() {
    super.initState();
    _prepareText();
    _initTTS();
  }

  void _prepareText() {
    String cleanedText = widget.newsContent
        .replaceAll(RegExp(r'[*•▲■✔︎◉❖→⇒➤➔➥➢➣➤➥➦➧➨➩➪➫➬➭➮➯➱➲➳➵➶➷➸➹➺➻➼➽➾]'),
            '') // remove bullet points & symbols
        .replaceAll(RegExp(r'\s+'), ' ') // normalize whitespace
        .replaceAll(RegExp(r'[_#@^%~|\\/]'), '') // remove unwanted characters
        .trim();
    sentences = cleanedText.split(RegExp(r'(?<=[.!?])\s+'));
    //sentences = widget.newsContent.split(RegExp(r'(?<=[.!?])\s+'));
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage(widget.languageCode);
    await flutterTts.setSpeechRate(playbackSpeed);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _startTTS() async {
    if (currentIndex >= sentences.length) {
      setState(() => currentIndex = 0);
    }
    setState(() => isPlaying = true);
    _speakSentence(currentIndex);
  }

  void _speakSentence(int index) async {
    if (!isPlaying || index >= sentences.length) {
      setState(() => isPlaying = false);
      return;
    }

    await flutterTts.stop(); // Prevent overlapping
    await flutterTts.speak(sentences[index]);

    flutterTts.setCompletionHandler(() async {
      if (!isPlaying) return;

      setState(() {
        currentIndex = index + 1;
      });

      if (currentIndex < sentences.length) {
        _scrollController.scrollTo(
          index: currentIndex,
          duration: const Duration(milliseconds: 500),
        );
        _speakSentence(currentIndex);
      } else {
        setState(() => isPlaying = false);
      }
    });

    // Optional: Scroll immediately when sentence starts
    _scrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _stopTTS() async {
    await flutterTts.stop();
    setState(() => isPlaying = false);
  }

  void _changeSpeed(double speed) {
    setState(() {
      playbackSpeed = speed;
    });
    flutterTts.setSpeechRate(speed);
  }

  void _skipNext() {
    if (currentIndex < sentences.length - 1) {
      setState(() => currentIndex++);
      _scrollController.scrollTo(
        index: currentIndex,
        duration: const Duration(milliseconds: 300),
      );
      if (isPlaying) {
        _speakSentence(currentIndex);
      }
    }
  }

  void _skipPrevious() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _scrollController.scrollTo(
        index: currentIndex,
        duration: const Duration(milliseconds: 300),
      );
      if (isPlaying) {
        _speakSentence(currentIndex);
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Podcast Mode'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / sentences.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${((currentIndex + 1) / sentences.length * 100).toStringAsFixed(0)}% completed',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemCount: sentences.length,
              itemBuilder: (context, index) {
                bool isActive = index == currentIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.grey[800],
                    ),
                    child: Text(sentences[index]),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 36),
                onPressed: _skipPrevious,
              ),
              IconButton(
                icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 48),
                onPressed: () {
                  isPlaying ? _stopTTS() : _startTTS();
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 36),
                onPressed: _skipNext,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined, size: 48),
                onPressed: _stopTTS,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Speed:'),
              const SizedBox(width: 8),
              DropdownButton<double>(
                value: playbackSpeed,
                items: const [
                  DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                  DropdownMenuItem(value: 1.0, child: Text('1x')),
                  DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                  DropdownMenuItem(value: 2.0, child: Text('2x')),
                ],
                onChanged: (value) {
                  if (value != null) _changeSpeed(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
