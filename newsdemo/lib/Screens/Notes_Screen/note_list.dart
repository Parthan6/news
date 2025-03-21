import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/Notes_Screen/add_edit.dart';
import 'package:newsdemo/Screens/Notes_Screen/notes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  String searchQuery = '';
  bool showFavoritesOnly = false;
  bool newestFirst = true;
  List<String> allTags = [];
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> noteStrings = prefs.getStringList('notes') ?? [];
    final savedNotes = noteStrings.map((e) {
      final Map<String, dynamic> map = json.decode(e);
      return Note.fromJson(map);
    }).toList();

    final favOnly = prefs.getBool('showFavoritesOnly') ?? false;
    final sortNewest = prefs.getBool('newestFirst') ?? true;

    setState(() {
      notes = savedNotes;
      allTags = {
        for (var note in notes) ...note.tags,
      }.toSet().toList();
      showFavoritesOnly = favOnly;
      newestFirst = sortNewest;
      applyFilters();
    });
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteStrings = notes.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('notes', noteStrings);
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showFavoritesOnly', showFavoritesOnly);
    await prefs.setBool('newestFirst', newestFirst);
  }

  void applyFilters() {
    List<Note> temp = List.from(notes);
    if (searchQuery.isNotEmpty) {
      temp = temp.where((note) {
        final q = searchQuery.toLowerCase();
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q) ||
            note.tags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();
    }

    if (showFavoritesOnly) {
      temp = temp.where((note) => note.isFavorite).toList();
    }

    if (selectedTags.isNotEmpty) {
      temp = temp
          .where((note) => note.tags.any((tag) => selectedTags.contains(tag)))
          .toList();
    }

    temp.sort((a, b) => newestFirst
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));

    setState(() {
      filteredNotes = temp;
    });
  }

  void addOrEditNote({Note? existingNote, int? index}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NoteEditorPage(
                  note: existingNote,
                  onSave: (newNote) {
                    setState(() {
                      if (index != null) {
                        notes[index] = newNote;
                      } else {
                        notes.add(newNote);
                      }
                      allTags = {
                        for (var note in notes) ...note.tags,
                      }.toSet().toList();
                    });
                    saveNotes();
                    applyFilters();
                  },
                )));
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      allTags = {
        for (var note in notes) ...note.tags,
      }.toSet().toList();
    });
    saveNotes();
    applyFilters();
  }

  void toggleFavorite(Note note) {
    note.isFavorite = !note.isFavorite;
    saveNotes();
    applyFilters();
  }

  void shareNote(Note note) {
    Share.share(
        '${note.title}\nTags: ${note.tags.join(", ")}\n\n${note.content}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(
                showFavoritesOnly ? Icons.star : Icons.star_border_outlined),
            tooltip: 'Favorites Filter',
            onPressed: () {
              setState(() => showFavoritesOnly = !showFavoritesOnly);
              savePreferences();
              applyFilters();
            },
          ),
          IconButton(
            icon: Icon(newestFirst ? Icons.sort_by_alpha : Icons.sort),
            tooltip: 'Toggle Sort',
            onPressed: () {
              setState(() => newestFirst = !newestFirst);
              savePreferences();
              applyFilters();
            },
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextField(
                    onChanged: (val) {
                      searchQuery = val;
                      applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: allTags.map((tag) {
                      final selected = selectedTags.contains(tag);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(tag),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              selected
                                  ? selectedTags.remove(tag)
                                  : selectedTags.add(tag);
                            });
                            applyFilters();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            )),
      ),
      body: filteredNotes.isEmpty
          ? const Center(child: Text('No notes found'))
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (_, index) {
                final note = filteredNotes[index];
                final originalIndex = notes.indexOf(note);
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                        '${note.content.length > 100 ? note.content.substring(0, 100) + "..." : note.content}\nTags: ${note.tags.join(", ")}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'edit') {
                          addOrEditNote(
                              existingNote: note, index: originalIndex);
                        } else if (val == 'delete') {
                          deleteNote(originalIndex);
                        } else if (val == 'share') {
                          shareNote(note);
                        } else if (val == 'fav') {
                          toggleFavorite(note);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                            value: 'fav',
                            child: Text(
                                note.isFavorite ? 'Unfavorite' : 'Favorite')),
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'delete', child: Text('Delete')),
                        const PopupMenuItem(
                            value: 'share', child: Text('Share')),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
