import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsdemo/Models/indian_news_model.dart';

class IndianNews {
  //String title = '';
  //String content = '';

  Future<List<IndianNewsModel>> fetchIndian() async {
    final String url = 'http://10.0.2.2:10000/fetch_news';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> newsList = json.decode(response.body)['news'];
        //print(newsList);
        return newsList.map((data) => IndianNewsModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
