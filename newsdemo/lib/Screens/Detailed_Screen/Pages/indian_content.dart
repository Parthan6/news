import 'package:flutter/material.dart';
import 'package:newsdemo/Services/summarize_content.dart';

class IndianContent extends StatefulWidget {
  final String link;
  final List<String?> newsList;
  final int index;

  const IndianContent({
    super.key,
    required this.link,
    required this.newsList,
    required this.index,
  });

  @override
  State<IndianContent> createState() => _IndianContentState();
}

class _IndianContentState extends State<IndianContent> {
  late Future<String> content;

  @override
  void initState() {
    super.initState();
    if (widget.newsList[widget.index] == null) {
      content = Summarize().fetchSummary(widget.link).then((summary) {
        setState(() {
          widget.newsList[widget.index] = summary;
        });
        return summary;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.newsList[widget.index] != null
        ? Text(widget.newsList[widget.index]!)
        : FutureBuilder<String>(
            future: content,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Failed to summarize content"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No summary available"));
              }

              return Text(snapshot.data!);
            },
          );
  }
}
