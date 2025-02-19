import 'package:flutter/material.dart';
import 'package:newsdemo/Models/indian_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/Indian_content.dart';
import 'package:newsdemo/Services/indian_news.dart';

class IndianNewsList extends StatefulWidget {
  const IndianNewsList({super.key});

  @override
  State<IndianNewsList> createState() => _IndianNewsListState();
}

class _IndianNewsListState extends State<IndianNewsList> {
  late Future<List<IndianNewsModel>> news;

  @override
  void initState() {
    news = IndianNews().fetchIndian();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: news,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                itemBuilder: (context, index) {
                  final newsItem = snapshot.data![index];

                  return ListTile(
                    title: Text(newsItem.title),
                    subtitle: IndianContent(
                      link: newsItem.content,
                    ),
                  );
                },
                itemCount: snapshot.data!.length);
          }),
    );
  }
}
