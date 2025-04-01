import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final notesController = TextEditingController();

  void addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: notesController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              saveNote();
              Navigator.of(context).pop();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void saveNote() async {
    await Supabase.instance.client.from('notes').insert({'body': notesController.text});
  }

  final _noteStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _noteStream,
          builder: (context, snapshot) {
            // loading
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // loaded
            final notes = snapshot.data!;
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  // get individual note
                  final note = notes[index];

                  // get column values
                  final noteText = note['body'];

                  // return as UI
                  return Text(noteText);
                });
          }),
    );
  }
}
