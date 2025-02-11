import 'package:flutter/material.dart';

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark'),
      ),
      body: Text('bookmark'),
    );
  }
}
