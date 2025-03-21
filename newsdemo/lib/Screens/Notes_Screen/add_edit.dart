import 'package:flutter/material.dart';
import 'package:newsdemo/Screens/Notes_Screen/notes.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const NoteEditorPage({super.key, this.note, required this.onSave});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  List<String> selectedTags = [];
  Color selectedColor = Colors.black;

  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;

  final List<String> availableTags = ['Work', 'Personal', 'Urgent', 'Idea'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
    selectedTags = widget.note?.tags ?? [];
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveNote() {
    final note = Note(
      title: titleController.text,
      content: contentController.text,
      tags: selectedTags,
      isFavorite: widget.note?.isFavorite ?? false,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );
    widget.onSave(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(onPressed: saveNote, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: isBold ? Colors.teal : Colors.grey),
                  onPressed: () {
                    setState(() => isBold = !isBold);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_italic,
                      color: isItalic ? Colors.teal : Colors.grey),
                  onPressed: () {
                    setState(() => isItalic = !isItalic);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_underline,
                      color: isUnderline ? Colors.teal : Colors.grey),
                  onPressed: () {
                    setState(() => isUnderline = !isUnderline);
                  },
                ),
                const Spacer(),
                DropdownButton<Color>(
                  value: selectedColor,
                  items: [
                    Colors.black,
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange
                  ].map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: color,
                      ),
                    );
                  }).toList(),
                  onChanged: (color) {
                    if (color != null) {
                      setState(() => selectedColor = color);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: TextStyle(
                  color: selectedColor,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
                decoration: const InputDecoration(
                  hintText: 'Type your note...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: availableTags.map((tag) {
                final selected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selected
                          ? selectedTags.remove(tag)
                          : selectedTags.add(tag);
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
