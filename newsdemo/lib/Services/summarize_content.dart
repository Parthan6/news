import 'dart:convert';

import 'package:http/http.dart' as http;

class Summarize {
  String title = '';
  String content = '';

  Future<String> fetchSummary(String url) async {
    // final response = await http.post(
    //   Uri.parse(
    //       //'https://news-content-backend.vercel.app/summarize'),
    //       //'http://10.0.2.2:10000/summarize'),
    //       'https://newscontentbackend-5.onrender.com/summarize'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({'url': url}),
    // );
    final response = await http.get(Uri.parse(
        //'https://newscontentbackend-9.onrender.com/summarize?url=$url'));
        'http://10.0.2.2:8000/summarize?url=$url'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      title = data['title'];
      content = data['summary'];
      return content;
    } else {
      throw Exception('Error...');
    }
  }
}
