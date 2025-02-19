import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Pages/indian_news_list.dart';
import 'package:newsdemo/Screens/Home_Screen/Widgets/categories_widget.dart';
import 'package:newsdemo/Screens/Home_Screen/Widgets/trending_news.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Today's News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndianNewsList()));
                  },
                  child: Text(
                    'Indian News',
                    style: TextStyle(color: Colors.white),
                  )),
              Text(
                'Top Trending',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              TopTrending(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Categories',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
