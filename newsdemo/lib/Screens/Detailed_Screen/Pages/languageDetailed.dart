import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsdemo/Models/indian_news_model.dart';
import 'package:newsdemo/Models/language_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/Indian_content.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/add_bookmark.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/voice.dart';
import 'package:newsdemo/Services/indian_news.dart';
import 'package:newsdemo/Services/language_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageNewsList extends StatefulWidget {
  String url;
  LanguageNewsList({super.key, required this.url});

  @override
  State<LanguageNewsList> createState() => _LanguageNewsListState();
}

class _LanguageNewsListState extends State<LanguageNewsList> {
  late Future<List<LanguageNewsModel>> news;
  //List<String?> newsSummaries = []; // Stores fetched summaries
  //bool marked = false;

  @override
  void initState() {
    super.initState();
    news = LanguageNews().fetchLanguageNews(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Indian News")),
      body: FutureBuilder<List<LanguageNewsModel>>(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.data);
            return Center(child: Text("Failed to load news"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No news available"));
          }

          // Initialize the summary list with null values
          // if (newsSummaries.isEmpty) {
          //   newsSummaries = List<String?>.filled(snapshot.data!.length, null);
          // }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final newsItem = snapshot.data![index];

              return ListTile(
                  title: Text(
                    newsItem.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: GestureDetector(
                      onTap: () => launchUrl(Uri.parse(newsItem.link)),
                      child: Text(newsItem.link)));
            },
          );
        },
      ),
    );
  }
}
