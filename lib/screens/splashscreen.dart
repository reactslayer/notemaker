import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _width = 0;
  double _height = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _width = 150;
        _height = 150;
      });
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      width: _width,
                      height: _height,
                      child: Image.asset(
                        'assets/images/notes.png',
                      )),
                  borderRadius: BorderRadius.circular(50)),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "NOTES",
                style: GoogleFonts.abel(
                    textStyle: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 50)),
              ),
            ],
          )),
    );
  }
}
