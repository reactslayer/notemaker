import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/screens/addnote.dart';
import 'package:notesapp/screens/readnote.dart';
import 'package:notesapp/screens/splashscreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Database>? database;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void updateList() async {
    List<Note> dataa = await getnotes();
    print(dataa.length);
    List<Widget> holder = [];

    dataa.forEach((element) {
      holder.add(GestureDetector(
        onTap: () {
          gotoRead(element);
        },
        child: Card(
            elevation: 2,
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.all(15),
                    child: Icon(
                      Icons.assignment,
                      size: 25,
                      fill: 0.1,
                      color: Colors.blue,
                    )),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    element.title,
                    style: GoogleFonts.bitter(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.all(15),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever_rounded),
                        onPressed: () => {delete(element)},
                        iconSize: 25,
                        color: Colors.red,
                      )),
                ),
              ],
            )),
      ));
    });
    setState(() {
      notes = holder;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialRun();
  }

  List<Widget> notes = [];
  void initialRun() async {
    database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'data.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE IF NOT EXISTS notes(id INTEGER PRIMARY KEY DEFAULT 1, title TEXT, description TEXT)');
    }, version: 1);

    // Note note1 = Note(id: 1, title: "Note 1", description: "Hey this is note1");
    // Note note2 = Note(id: 2, title: "Note 2", description: "Hey this is note2");

    // Note note3 = Note(id: 3, title: "Note 3", description: "Hey this is note3");

    // await addNote(note1);
    // await addNote(note2);

    // await addNote(note3);
    List<Note> dataa = await getnotes();
    print(dataa.length);
    List<Widget> holder = [];

    dataa.forEach((element) {
      holder.add(GestureDetector(
        onTap: () {
          gotoRead(element);
        },
        child: Card(
            elevation: 2,
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.all(15),
                    child: Icon(
                      Icons.assignment,
                      size: 25,
                      fill: 0.1,
                      color: Colors.blue,
                    )),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    element.title,
                    style: GoogleFonts.bitter(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.all(15),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever_rounded),
                        onPressed: () => {delete(element)},
                        iconSize: 25,
                        color: Colors.red,
                      )),
                ),
              ],
            )),
      ));
    });
    setState(() {
      notes = holder;
    });
  }

  void gotoRead(Note element) {
    print("inside");
    if (cont == null) {
      print("cont si null");
      return;
    }
    Navigator.push(cont!,
        MaterialPageRoute(builder: (context) => ReadNote(note: element)));
  }

  Future<void> delete(note) async {
    assert(note != null);
    deleteNote(note.id);
    updateList();
  }

  Future<void> deleteNote(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db?.delete(
      'notes',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<List<Note>> getnotes() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic?>>? maps = await db?.query('notes');
    int len;
    if (maps == null) {
      print("maps is null");
      len = 0;
      return [];
    } else {
      len = maps.length;
    }
    // Convert the List<Map<String, dynamic> into a List<Dog>.

    return List.generate(len, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  BuildContext? cont;
  @override
  Widget build(BuildContext context) {
    cont = context;
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNote(
                        updateList: updateList,
                      )))
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            children: notes,
          )),
    ));
  }
}
