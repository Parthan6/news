import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/BookMark_Screen/bookmark.dart';
import 'package:newsdemo/Screens/Calender_Screen/calender.dart';
import 'package:newsdemo/authCheck.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Calendar()));
                },
                child: Text('News Archive')),
            Icon(
              Icons.person,
              size: 200,
            ),
            Text(
              user!.email!,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookMark()));
                },
                child: Text('Bookmark')),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Log out'))
          ],
        ),
      ),
    );
  }
}
