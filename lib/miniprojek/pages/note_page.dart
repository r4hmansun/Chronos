import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import 'detail_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List<Note> notes = [];
  String search = "";

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await StorageService.loadList("notes");
    setState(() {
      notes = data.map((e) => Note.fromJson(e)).toList();
    });
  }

  Future<void> saveNotes() async {
    await StorageService.saveList(
      "notes",
      notes.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addNote() async {
    final title = TextEditingController();
    final content = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: content,
              decoration: const InputDecoration(labelText: "Isi"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (title.text.isNotEmpty) {
                notes.add(Note(title.text, content.text));
                await saveNotes();
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = notes
        .where((n) =>
            n.title.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari note...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => search = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.note),
                  ),
                  title: Text(filtered[i].title),
                  subtitle: const Text("Tap untuk melihat"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          filtered[i].title,
                          filtered[i].content,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}