import 'dart:convert';

import 'package:newsdemo/Models/top_news_model.dart';
import 'package:http/http.dart' as http;

const apiKey = "7becca76f77e4b62a4e73579f77250a3";

class TopNewsAPI {
  final APIurl =
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=${apiKey}";
  List<TopNews> newsData = [];
  Future<List<TopNews>?> getTopNews() async {
    Uri url = Uri.parse(APIurl);
    final response = await http.get(url);
    final jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      (jsonData['articles'].forEach((element) {
        if (element['title'] != null &&
            element['description'] != null &&
            element['urlToImage'] != null &&
            element['content'] != null &&
            element['url'] != null) {
          TopNews topNews = TopNews(element['title'], element['description'],
              element['urlToImage'], element['content'], element['url']);
          newsData.add(topNews);
        }
      }));
      return newsData;
    } else {
      throw Exception('Error occured');
    }
  }
}

class CategoryNewsAPI {
  List<TopNews> newsData = [];
  Future<List<TopNews>?> getCategoryNews(String? category) async {
    final APIurl =
        "https://newsapi.org/v2/top-headlines?country=us&category=${category}&apiKey=$apiKey";
    Uri url = Uri.parse(APIurl);
    final response = await http.get(url);
    final jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      (jsonData['articles'].forEach((element) {
        if (element['title'] != null &&
            element['description'] != null &&
            element['urlToImage'] != null &&
            element['content'] != null &&
            element['url'] != null) {
          TopNews topNews = TopNews(element['title'], element['description'],
              element['urlToImage'], element['content'], element['url']);
          newsData.add(topNews);
        }
      }));
      return newsData;
    } else {
      throw Exception('Error occured');
    }
  }
}
