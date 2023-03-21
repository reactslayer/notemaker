import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required VoidCallback this.updateList});
  final VoidCallback updateList;
  @override
  State<AddNote> createState() => _AddNoteState(this.updateList);
}

class _AddNoteState extends State<AddNote> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialRun();
  }

  VoidCallback? updatelist;
  Future<Database>? database = null;
  void initialRun() async {
    database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'data.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY DEFAULT 1, title TEXT, description TEXT)');
    }, version: 1);
  }

  Future<void> addNote(Note note) async {
    final db = await database;

    await db?.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Alignment title_alignment = Alignment.topLeft;
  String title_value = "";

  Alignment description_alignment = Alignment.topLeft;
  String description_value = "";
  _AddNoteState(VoidCallback updatelist) {
    this.updatelist = updatelist;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Container(
              child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            alignment: title_alignment,
            child: Card(
              margin: EdgeInsets.all(15),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  "Title",
                  style: GoogleFonts.inter(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          TextField(
            minLines: 1,
            maxLines: 1,
            onTap: () => setState(() {
              title_alignment = Alignment.center;
              description_alignment = Alignment.topLeft;
            }),
            onChanged: (value) {
              title_value = value;
            },
            onTapOutside: (event) => setState(() {
              title_alignment = Alignment.topLeft;
            }),
            decoration: InputDecoration(hintText: "Enter the title"),
          ),
          Padding(padding: EdgeInsets.all(25)),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            alignment: description_alignment,
            child: Card(
              margin: EdgeInsets.all(15),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  "Description",
                  style: GoogleFonts.inter(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          TextField(
            minLines: 10,
            maxLines: 13,
            onTap: () => setState(() {
              description_alignment = Alignment.center;
              title_alignment = Alignment.topLeft;
            }),
            onChanged: (value) {
              description_value = value;
            },
            onTapOutside: (event) => setState(() {
              description_alignment = Alignment.topLeft;
            }),
            decoration: InputDecoration(hintText: "Describe it..."),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: MaterialButton(
              elevation: 20,
              onPressed: () async {
                if (description_value == "" || title_value == "") {
                  Fluttertoast.showToast(
                      msg: 'Cannot add note!',
                      backgroundColor: Colors.grey,
                      fontSize: 15);
                  return;
                }
                await addNote(Note(
                        description: description_value, title: title_value))
                    .whenComplete(() => Fluttertoast.showToast(
                        msg: 'Added Successfully!',
                        backgroundColor: Colors.grey,
                        fontSize: 15));

                updatelist!();
              },
              child: Text(
                "Add Note",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          )
        ],
      ))),
    );
  }
}
