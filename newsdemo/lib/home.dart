import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/BookMark_Screen/bookmark.dart';
import 'package:newsdemo/Screens/Calender_Screen/calender.dart';
import 'package:newsdemo/Screens/Home_Screen/Pages/home_screen.dart';
import 'package:newsdemo/Screens/Notes_Screen/notes.dart';
import 'package:newsdemo/Screens/Profile_Screen/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  List<Widget> ScreenList = [
    HomeScreen(),
    Calender(),
    BookMark(),
    Notes(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: ScreenList,
        index: currentPageIndex,
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_view_day_rounded), label: 'Calender'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_rounded), label: 'Bookmark'),
          NavigationDestination(
              icon: Icon(Icons.notes_rounded), label: 'Notes'),
          NavigationDestination(
              icon: Icon(Icons.person_2_rounded), label: 'Profile'),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
