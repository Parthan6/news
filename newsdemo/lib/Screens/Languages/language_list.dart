import 'package:flutter/material.dart';
import 'package:newsdemo/Models/language.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/languageDetailed.dart';

class LanguageList extends StatelessWidget {
  const LanguageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regional Languages'),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          var language = Languages().languages[index];
          return GestureDetector(
            child: ListTile(
              title: Text(language['local']!),
              subtitle: Text(language['eng']!),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageNewsList(
                            url: language['link'].toString(),
                          )));
            },
          );
        }),
        itemCount: Languages().languages.length,
      ),
    );
  }
}
