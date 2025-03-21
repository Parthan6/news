import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsdemo/Models/indian_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/Indian_content.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/add_bookmark.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/voice.dart';
import 'package:newsdemo/Services/indian_news.dart';

class IndianNewsList extends StatefulWidget {
  const IndianNewsList({super.key});

  @override
  State<IndianNewsList> createState() => _IndianNewsListState();
}

class _IndianNewsListState extends State<IndianNewsList> {
  late Future<List<IndianNewsModel>> news;
  List<String?> newsSummaries = []; // Stores fetched summaries
  bool marked = false;

  @override
  void initState() {
    super.initState();
    news = IndianNews().fetchIndian();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Indian News")),
      body: FutureBuilder<List<IndianNewsModel>>(
        future: news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            //print(snapshot.data);
            return Center(child: Text("Failed to load news"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No news available"));
          }

          // Initialize the summary list with null values
          if (newsSummaries.isEmpty) {
            newsSummaries = List<String?>.filled(snapshot.data!.length, null);
          }

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
                subtitle: Column(
                  children: [
                    IndianContent(
                      link: newsItem.content,
                      newsList: newsSummaries,
                      index: index,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.bookmark),
                          onPressed: () {
                            addBookmark(newsItem.title,
                                newsSummaries[index].toString());
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Voice(
                          text:
                              newsItem.title + newsSummaries[index].toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
