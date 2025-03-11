import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class Calendar extends StatefulWidget {
  @override
  _NewsCalendarScreenState createState() => _NewsCalendarScreenState();
}

class _NewsCalendarScreenState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();
  String apiUrl = "http://10.0.2.2:5000/fetch_stored_news?date=";
  //'https://newscontentbackend-8.onrender.com/fetch_stored_news?date=';

  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<Map<String, dynamic>> fetchNews(String date) async {
    final response = await http.get(Uri.parse("$apiUrl$date"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("No news available for this date.");
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });

    String formattedDate =
        "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("View News"),
        content: Text("Would you like to view news online or download?"),
        actions: [
          TextButton(
            onPressed: () {
              _viewOnline(formattedDate);
              Navigator.pop(context);
            },
            child: Text("View Online"),
          ),
          TextButton(
            onPressed: () async {
              await _downloadNewsAsPDF(formattedDate);
              Navigator.pop(context);
            },
            child: Text("Download PDF"),
          ),
        ],
      ),
    );
  }

  void _viewOnline(String date) async {
    Uri driveLink = Uri.parse(
        "https://drive.google.com/open?id=your_drive_id"); // Replace with actual drive link
    if (await canLaunchUrl(driveLink)) {
      await launchUrl(driveLink);
    } else {
      throw "Could not open the file.";
    }
  }

  Future<void> _downloadNewsAsPDF(String date) async {
    try {
      Map<String, dynamic> newsData = await fetchNews(date);
      List<dynamic> indianNews = newsData["indian_news"];
      List<dynamic> internationalNews = newsData["international_news"];
      final customFont = await loadCustomFont();

      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Text(
              "News Summary - $date",
              style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                  fontFallback: [customFont]),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Indian News",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont,
                    fontFallback: [customFont])),
            for (var news in indianNews)
              pw.Text("${news['title']}\n${news['content']}\n\n"),
            pw.Text("International News",
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: customFont,
                    fontFallback: [customFont])),
            for (var news in internationalNews)
              pw.Text("${news['title']}\n${news['summary']}\n\n"),
          ],
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/news_$date.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("PDF Downloaded: $filePath")));
        OpenFile.open(filePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to download PDF.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News Calendar")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2023, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.month,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
          ),
        ],
      ),
    );
  }
}
