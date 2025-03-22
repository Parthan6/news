import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newsdemo/Models/indian_news_model.dart';
import 'package:newsdemo/Models/language_model.dart';

class LanguageNews {
  //String title = '';
  //String content = '';

  Future<List<LanguageNewsModel>> fetchLanguageNews(String newsLink) async {
    //final String url = 'https://news-content-backend.vercel.app/fetch_news';
    final String url =
        'https://newscontentbackend-10.onrender.com/language_news?url=$newsLink';
    //final String url = 'http://10.0.2.2:6000/language_news?url=$newsLink';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> LanguagenewsList =
            json.decode(response.body)['news'];

        return LanguagenewsList.map((data) => LanguageNewsModel.fromJson(data))
            .toList();
      } else {
        print(response.body);
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching news: $e');
    }
  }
}
