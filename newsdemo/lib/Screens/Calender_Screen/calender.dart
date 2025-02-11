import 'package:flutter/material.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Date'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
              initialDate: DateTime(2025),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (DateTime) {}),
        ],
      ),
    );
  }
}
