// ignore_for_file: library_private_types_in_public_api

import 'package:digital_agenda/pages/components/colors.dart';
import 'package:flutter/material.dart';

import 'edit_note_page.dart';
import 'note.dart';
import 'note_card_widget.dart';
import 'note_detail_page.dart';
import 'notes_database.dart';

class NotlarSayfasi extends StatefulWidget {
  const NotlarSayfasi({Key? key}) : super(key: key);

  @override
  _NotlarSayfasiState createState() => _NotlarSayfasiState();
}

class _NotlarSayfasiState extends State<NotlarSayfasi> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.purple[50]!,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'Notlar',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'Not Eklenmedi!',
                      style: TextStyle(color: Color.fromARGB(255, 86, 86, 86), fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorUtility.buttonColor,
          child: const Icon(
            Icons.add,
            color: ColorUtility.defaultWhiteColor,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
