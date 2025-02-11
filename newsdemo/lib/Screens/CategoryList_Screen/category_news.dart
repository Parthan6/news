import 'package:flutter/material.dart';
import 'package:newsdemo/Models/top_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/details.dart';
import 'package:newsdemo/Services/service.dart';

class CategoryNews extends StatefulWidget {
  final String? category;
  const CategoryNews({super.key, required this.category});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  //late Future<List<TopNews>> categorynews;
  late List<TopNews> articles = [];

  getNews() async {
    CategoryNewsAPI categorynews = CategoryNewsAPI();
    await categorynews.getCategoryNews(widget.category);
    setState(() {
      articles = categorynews.newsData;
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: (articles.isEmpty)
            ? CircularProgressIndicator()
            : ListView.builder(itemBuilder: (context, index) {
                TopNews article = articles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                                category: widget.category.toString(),
                                news: article)));
                  },
                  child: Column(
                    children: [
                      Image.network(article.urlToImage.toString()),
                      Text(
                        article.title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(article.description.toString()),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  ),
                );
              }));
  }
}
