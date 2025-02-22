import 'package:flutter/material.dart';
import 'package:newsdemo/Models/top_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/voice.dart';
import 'package:newsdemo/Services/summarize_content.dart';

class DetailsScreen extends StatefulWidget {
  final String category;
  final TopNews news;
  DetailsScreen({super.key, required this.category, required this.news});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<String> content;

  @override
  void initState() {
    content = Summarize().fetchSummary(widget.news.url!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.news.title.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(widget.news.urlToImage.toString()),
            FutureBuilder(
                future: content,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Text(snapshot.data.toString());
                }),
            Voice(
              text: widget.news.title.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
