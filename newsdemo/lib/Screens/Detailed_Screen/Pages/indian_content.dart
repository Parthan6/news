import 'package:flutter/material.dart';
import 'package:newsdemo/Services/summarize_content.dart';

class IndianContent extends StatefulWidget {
  final String link;
  List newsList;
  IndianContent({super.key, required this.link, required this.newsList});

  @override
  State<IndianContent> createState() => _IndianContentState();
}

class _IndianContentState extends State<IndianContent> {
  late Future<String> content;

  @override
  void initState() {
    content = Summarize().fetchSummary(widget.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: content,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          widget.newsList.add(snapshot.data);
          return Text(snapshot.data.toString());
        });
  }
}
