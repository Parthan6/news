import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Center(child: Text("Please log in"));

    void deleteBookmark(var bookmark) {
      bookmark.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bookmark removed")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Bookmarked News")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No bookmarks found"));
          }

          var bookmarks = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              var bookmark = bookmarks[index];
              return ListTile(
                title: Text(bookmark['title']),
                subtitle: Column(
                  children: [
                    Text(bookmark['content']),
                    Text(bookmark['date']),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    deleteBookmark(bookmark);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
