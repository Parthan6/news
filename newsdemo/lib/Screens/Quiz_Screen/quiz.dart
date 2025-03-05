import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsQuizApp extends StatefulWidget {
  @override
  _NewsQuizAppState createState() => _NewsQuizAppState();
}

class _NewsQuizAppState extends State<NewsQuizApp> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    const apiKey = "AIzaSyCHeYLQvve5TxznqMmEuEtH7btM1ib-L2I";
    const url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Generate 10 multiple-choice questions based on today's latest news, including Indian news. Each question should have 4 options and the correct answer. Provide the output in JSON format."
              }
            ]
          }
        ]
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String rawJson = data["candidates"][0]["content"]["parts"][0]["text"];
      rawJson = rawJson.replaceAll(RegExp(r'```json|```'), '').trim();
      final content = jsonDecode(rawJson);

      setState(() {
        questions = List<Map<String, dynamic>>.from(content);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == questions[currentQuestion]['answer']) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      showResult();
    }
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed!"),
        content: Text("Your Score: $score / ${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentQuestion = 0;
                score = 0;
                isLoading = true;
              });
              fetchQuestions();
              Navigator.pop(context);
            },
            child: Text("Play Again"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("News Quiz")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : questions.isEmpty
                ? Center(child: Text("No questions available"))
                : Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Question ${currentQuestion + 1}:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(questions[currentQuestion]['question'],
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 20),
                        ...questions[currentQuestion]['options']
                            .map((option) => ElevatedButton(
                                  onPressed: () => checkAnswer(option),
                                  child: Text(option),
                                )),
                      ],
                    ),
                  ),
      ),
    );
  }
}



//AIzaSyCHeYLQvve5TxznqMmEuEtH7btM1ib-L2I