import 'package:flutter/material.dart';
import 'package:newsdemo/Services/summarize_content.dart';

class IndianContent extends StatefulWidget {
  final String link;
  IndianContent({super.key, required this.link});

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
          return Text(snapshot.data.toString());
        });
  }
}
