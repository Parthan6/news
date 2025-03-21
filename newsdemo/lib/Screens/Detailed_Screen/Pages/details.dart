import 'package:flutter/material.dart';
import 'package:newsdemo/Models/top_news_model.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/add_bookmark.dart';
import 'package:newsdemo/Screens/Detailed_Screen/Services/voice.dart';
import 'package:newsdemo/Services/summarize_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsScreen extends StatefulWidget {
  final String category;
  final TopNews news;
  DetailsScreen({super.key, required this.category, required this.news});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<String> content;
  String newsContent = '';
  late bool isBookmarked = false;

  @override
  void initState() {
    content = Summarize().fetchSummary(widget.news.url!);

    content.then((summary) {
      setState(() {
        newsContent = summary;
      });
    });

    checkIfBookmarked();
    super.initState();
  }

  void checkIfBookmarked() async {
    bool exists = await isBookmarkedInFirestore(widget.news.title.toString());
    if (mounted) {
      setState(() {
        isBookmarked = exists;
      });
    }
  }

  Future<void> removeBookmarkFromFirestore(String title) async {
    try {
      final bookmarksCollection =
          FirebaseFirestore.instance.collection('bookmarks');

      // Query Firestore for the document with the matching title
      QuerySnapshot querySnapshot =
          await bookmarksCollection.where('title', isEqualTo: title).get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete(); // Delete the matching document
      }
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.news.title.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.network(widget.news.urlToImage.toString()),
            FutureBuilder(
                future: content,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return Text(newsContent);
                }),
            Row(
              children: [
                Voice(
                  text: widget.news.title.toString() + '\n' + newsContent,
                ),
                IconButton(
                    onPressed: () async {
                      if (!isBookmarked) {
                        addBookmark(
                          widget.news.title.toString(),
                          newsContent,
                        );
                        setState(() {
                          isBookmarked = true;
                        });
                      } else {
                        await removeBookmarkFromFirestore(
                            widget.news.title.toString());
                        setState(() {
                          isBookmarked = false;
                        });
                      }
                    },
                    icon: isBookmarked
                        ? Icon(Icons.bookmark)
                        : Icon(Icons.bookmark_border_rounded))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
