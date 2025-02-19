import 'dart:convert';

import 'package:http/http.dart' as http;

class Summarize {
  String title = '';
  String content = '';

  Future<String> fetchSummary(String url) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/summarize'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'url': url}),
    );

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
