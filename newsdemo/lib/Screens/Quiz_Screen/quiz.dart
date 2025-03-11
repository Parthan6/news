import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NewsQuizApp extends StatefulWidget {
  @override
  _NewsQuizAppState createState() => _NewsQuizAppState();
}

class _NewsQuizAppState extends State<NewsQuizApp> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0;
  int score = 0;
  bool isLoading = true;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedDate = prefs.getString("quiz_date");
    String? storedQuestions = prefs.getString("quiz_questions");
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (storedDate == today && storedQuestions != null) {
      setState(() {
        questions =
            List<Map<String, dynamic>>.from(jsonDecode(storedQuestions));
        isLoading = false;
      });
    } else {
      fetchQuestions();
    }
  }

  Future<void> fetchQuestions() async {
    const apiKey = "AIzaSyCHeYLQvve5TxznqMmEuEtH7btM1ib-L2I";
    const url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String rawJson = data["candidates"][0]["content"]["parts"][0]["text"];
      rawJson = rawJson.replaceAll(RegExp(r'```json|```'), '').trim();
      final content = jsonDecode(rawJson);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await prefs.setString("quiz_date", today);
      await prefs.setString("quiz_questions", jsonEncode(content));

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
    setState(() {
      selectedAnswer = selectedOption;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          selectedAnswer = null;
        });
      } else {
        showResult();
      }
    });
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your Score: $score / ${questions.length}"),
            SizedBox(height: 10),
            Text("Click below to retry today's quiz."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentQuestion = 0;
                score = 0;
                selectedAnswer = null;
              });
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
    return Scaffold(
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
                      Text(
                        "Question ${currentQuestion + 1}:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(questions[currentQuestion]['question'],
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                      ...questions[currentQuestion]['options'].map((option) {
                        bool isCorrect =
                            option == questions[currentQuestion]['answer'];
                        bool isSelected = option == selectedAnswer;

                        return ElevatedButton(
                          onPressed: selectedAnswer == null
                              ? () {
                                  if (isCorrect) score++;
                                  checkAnswer(option);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedAnswer == null
                                ? Colors.blue
                                : isSelected
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : (isCorrect ? Colors.green : Colors.grey),
                          ),
                          child: Text(option),
                        );
                      }),
                      if (selectedAnswer != null) ...[
                        SizedBox(height: 20),
                        Text(
                          "Correct Answer: ${questions[currentQuestion]['answer']}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
