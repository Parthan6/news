import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newsdemo/Models/top_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/details.dart';
import 'package:newsdemo/Services/service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TopTrending extends StatefulWidget {
  const TopTrending({super.key});

  @override
  State<TopTrending> createState() => _TopTrendingState();
}

class _TopTrendingState extends State<TopTrending> {
  late Future<List<TopNews>?> topNews;

  @override
  void initState() {
    topNews = TopNewsAPI().getTopNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topNews,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final newsList = snapshot.data!;
          return CarouselSlider.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index, newsIndex) {
              final topnews = newsList[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    category: 'Trending',
                                    news: topnews,
                                  )));
                    },
                    child: Container(
                      width: 275,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image:
                                  NetworkImage(topnews.urlToImage.toString()),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          Text(
                            topnews.title.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            topnews.description.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: 450,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
            ),
          );
        });
  }
}
