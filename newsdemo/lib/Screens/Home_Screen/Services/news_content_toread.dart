import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ContentFetch {
  final String apiUrl =
      'https://newscontentbackend-8.onrender.com/fetch_stored_news?date=';

  // Fetch news from your backend
  Future<Map<String, dynamic>> fetchNews(String date) async {
    final response = await http.get(Uri.parse("$apiUrl$date"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("No news available for this date.");
    }
  }

  // Convert news content into a podcast script using Gemini API
  Future<String?> generatePodcastScript({
    required String date,
    required String language,
  }) async {
    try {
      // Fetch news from your backend (MongoDB)
      Map<String, dynamic> newsData = await fetchNews(date);
      List<dynamic> indianNews = newsData["indian_news"];
      List<dynamic> internationalNews = newsData["international_news"];

      // Prepare content for Gemini API
      final String newsContent =
          "Indian News: ${indianNews.join('. ')}. International News: ${internationalNews.join('. ')}";

      const apiKey = "AIzaSyCHeYLQvve5TxznqMmEuEtH7btM1ib-L2I";
      const geminiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

      final response = await http.post(
        Uri.parse(geminiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Convert this news content into a natural, podcast-like script in $language. Make it sound like a human host is reading it to an audience: $newsContent"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //print(jsonResponse["candidates"][0]["content"]["parts"][0]["text"]);
        return jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        throw Exception("Gemini API call failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error generating podcast script: $e");
      return null;
    }
  }
}
