import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBack = true;
  double angle = 0;
  int currentBackIndex = 1; // Start with the first back image

  String get currentBackImage {
    return 'assets/Player-$currentBackIndex.png';
  }

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
      if (angle == 0) {
        isBack = !isBack; // Toggle between front and back
        if (!isBack) {
          currentBackIndex = (currentBackIndex % 20) +
              1; // Cycle through Player-1.png to Player-20.png
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _flip,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: Duration(seconds: 1),
                  builder: (BuildContext context, double val, __) {
                    isBack = val >= (pi / 2);
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(val),
                      child: Container(
                        width: 309,
                        height: 474,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage(
                              isBack ? 'assets/back.png' : currentBackImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: isBack
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage("assets/face.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Mr.Beast",
                                      style: TextStyle(
                                        fontSize: 120.0,
                                        color: Colors.red,
                                        fontFamily: 'TT-Bluescreens',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
