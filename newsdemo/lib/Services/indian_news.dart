import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsdemo/Models/indian_news_model.dart';

class IndianNews {
  //String title = '';
  //String content = '';

  Future<List<IndianNewsModel>> fetchIndian() async {
    //final String url = 'https://news-content-backend.vercel.app/fetch_news';
    //final String url = 'https://newscontentbackend-5.onrender.com/fetch_news';
    final String url = 'http://10.0.2.2:10000/fetch_news';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> newsList = json.decode(response.body)['news'];
        print(newsList);
        print('object');
        return newsList.map((data) => IndianNewsModel.fromJson(data)).toList();
      } else {
        print(response.body);
        print('...');
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
