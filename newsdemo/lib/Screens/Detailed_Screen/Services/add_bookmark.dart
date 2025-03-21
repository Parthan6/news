import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addBookmark(String title, String content) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final bookmarkRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('bookmarks');

  QuerySnapshot querySnapshot =
      await bookmarkRef.where('title', isEqualTo: title).get();

  if (querySnapshot.docs.isEmpty) {
    await bookmarkRef.add({
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    });
  }
}

Future<bool> isBookmarkedInFirestore(String title) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('bookmarks')
      .doc(title)
      .get();

  return doc.exists;
}
