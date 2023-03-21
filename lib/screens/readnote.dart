import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/note.dart';

class ReadNote extends StatefulWidget {
  final Note note;
  ReadNote({super.key, required this.note});

  @override
  State<ReadNote> createState() => _ReadNoteState();
}

class _ReadNoteState extends State<ReadNote> {
  final TextStyle head_style = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 20,
    color: Colors.black,
  );
  double title_elevation = 5;
  double description_elevation = 5;
  final TextStyle data_style = TextStyle(
    decoration: TextDecoration.none,
    fontSize: 18,
    color: Colors.grey[700],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Title",
                      style: head_style,
                    )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      title_elevation = 15;
                      description_elevation = 5;
                    });
                  },
                  child: Card(
                    elevation: title_elevation,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          widget.note.title,
                          style: data_style,
                        )),
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Description",
                      style: head_style,
                    )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      title_elevation = 5;
                      description_elevation = 15;
                    });
                  },
                  child: Card(
                    elevation: description_elevation,
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          widget.note.description,
                          style: data_style,
                        )),
                  ),
                )
              ],
            )));
  }
}
