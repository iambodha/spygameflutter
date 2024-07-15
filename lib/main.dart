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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isBack = true;
  double angle = 0;
  int cardIndex = 0;
  final int numberOfCards = 34;
  late AnimationController _controller;
  late Animation<double> _disappearAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _disappearAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
      if (!isBack) {
        Future.delayed(Duration(milliseconds: 500), () {
          _controller.forward().then((_) {
            setState(() {
              cardIndex = (cardIndex + 1) % numberOfCards;
              angle = 0;
              isBack = true;
              _controller.reset();
            });
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                onTap: () {
                  if (isBack) {
                    _flip();
                  } else {
                    _controller.forward().then((_) {
                      setState(() {
                        cardIndex = (cardIndex + 1) % numberOfCards;
                        angle = 0;
                        isBack = true;
                        _controller.reset();
                      });
                    });
                  }
                },
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: Duration(milliseconds: 500),
                  builder: (BuildContext context, double val, __) {
                    if (val >= (pi / 2)) {
                      isBack = false;
                    } else {
                      isBack = true;
                    }
                    return AnimatedBuilder(
                      animation: _disappearAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _disappearAnimation.value,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(val),
                            child: Container(
                              width: 309,
                              height: 474,
                              child: isBack
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: AssetImage("assets/back.png"),
                                        ),
                                      ),
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(pi),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image:
                                                AssetImage("assets/face.png"),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Surprise ! 🎊",
                                            style: TextStyle(
                                              fontSize: 30.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Card ${cardIndex + 1} of $numberOfCards",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
