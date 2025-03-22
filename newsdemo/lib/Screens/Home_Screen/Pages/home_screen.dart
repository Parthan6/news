import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/indian_news_list.dart';
import 'package:newsdemo/Screens/Home_Screen/Services/news_content_toread.dart';
import 'package:newsdemo/Screens/Home_Screen/Widgets/categories_widget.dart';
import 'package:newsdemo/Screens/Home_Screen/Widgets/hear.dart';
import 'package:newsdemo/Screens/Home_Screen/Widgets/trending_news.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<String?> _podcastFuture;

  @override
  void initState() {
    super.initState();
    _podcastFuture = getPodcastScript();
  }

  Future<String?> getPodcastScript() async {
    final contentFetcher = ContentFetch();
    final today = DateTime.now();
    final dateString =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    String? podcastScript = await contentFetcher.generatePodcastScript(
      date: dateString,
      language: "en",
    );
    return podcastScript;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Today's News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.hearing),
          onPressed: () async {
            String? toRead = await getPodcastScript();
            if (toRead != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPodcastPage(
                    newsContent: toRead,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Podcast content couldn't be generated.")),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndianNewsList()));
                  },
                  child: Text(
                    'Indian News',
                    style: TextStyle(color: Colors.white),
                  )),
              Text(
                'Top Trending',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              TopTrending(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Categories',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
