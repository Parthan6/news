import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/Notes_Screen/note_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const NoteListPage(),
    );
  }
}

class Note {
  String title;
  String content;
  List<String> tags;
  bool isFavorite;
  DateTime createdAt;

  Note({
    required this.title,
    required this.content,
    required this.tags,
    required this.isFavorite,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'tags': tags,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'],
        tags: List<String>.from(json['tags']),
        isFavorite: json['isFavorite'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
