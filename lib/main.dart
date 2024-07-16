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
  int currentBackIndex = 1;
  int playerCount = 3;
  int spyCount = 2;
  bool isAnimating = false;

  List<String> words = [
    'Monopoly',
    'Phone',
    'Laptop',
    'Headphones',
    'TV',
    'Parents',
    'Friends',
    'Husband/Wife',
    'Boyfriend/Husband',
    'Pizza',
    'Ramen',
    'Burger',
    'Sushi',
    'Hot Dog',
    'Dosa',
    'Chips',
    'Popcorn',
    'Cookie',
    'Paneer Tikka',
    'Smoothie',
    'Juice',
    'Water',
    'Fart',
    'Rain',
    'Snow',
    'Money',
    'Coins',
    'Camera',
    'Drone',
    'Disney',
    'Mouse',
    'Keyboard',
    'Microphone',
    'Rubix Cubes',
    'Toys',
    'Cooking',
    'Electricity',
    'Batman',
    'Flash',
    'Iron Man',
    'Spider Man',
    'Wonder Woman',
    'Super Man',
    'Thor',
    'Dustbin',
    'Gun',
    'Escape Room',
    'Sherlock Holmes',
    'Time',
    'Chess',
    'Football',
    'Basketball',
    'Volleyball',
    'Cristiano Ronaldo',
    'Dwayne Johnson(Rock)',
    'Johnny Depp',
    'Taylor Swift',
    'Robert Downey Jr.',
    'Leonardo DiCaprio',
    'Tom Cruise',
    'Bouldering',
    'Kayaking',
    'Paris',
    'Berlin',
    'New York City',
    'Skydiving',
    'Birthday',
    'Anniversary',
    'Mona Lisa',
    'New Year',
    'China',
    'Turkey',
    'India',
    'USA',
    'Germany',
    'Italy',
    'France',
    'South Africa',
    'Dog',
    'Cat',
    'Horse',
    'Human',
    'Cow',
    'Monkey',
    'Grandparents',
    'Japan',
    'Pencil',
    'Eraser',
    'Teacher',
    'Doctor',
    'Server',
    'Elon Musk',
    'Your Class Teacher',
    'Earth',
    'Mars',
    'Sun',
    'Moon',
    'Youtube',
    'Instagram',
    'Tiktok',
    'Snapchat',
    'Facebook',
    'MrBeast',
    'PewDiePie',
    'Selena Gomez',
    'Ed Sheeran',
    'Pyramid',
    'Great Wall of China',
    'Minecraft',
    'Fortnite',
    'GTA V',
    'Mario'
  ];

  List<String> modifyList() {
    if (currentBackIndex == 1) {
      Random random = Random();
      String randomWord = words[random.nextInt(words.length)];
      List<String> newList = List.filled(playerCount, randomWord);
      Set<int> uniqueIndices = {};

      while (uniqueIndices.length < spyCount) {
        int indexToReplace = random.nextInt(newList.length);
        uniqueIndices.add(indexToReplace);
      }

      List<int> uniqueIndicesList = uniqueIndices.toList();

      for (int indexToReplace in uniqueIndicesList) {
        newList[indexToReplace] = 'Spy';
      }
      return newList;
    } else {
      return [];
    }
  }

  List<String> modifiedList = [];

  @override
  void initState() {
    super.initState();
    modifiedList = modifyList();
  }

  String get currentBackImage {
    return 'assets/Player-$currentBackIndex.png';
  }

  void _flip() {
    if (isAnimating) {
      return; // Don't flip if animation is already in progress
    }

    setState(() {
      isAnimating = true; // Set animation flag
      angle = (angle + pi) % (2 * pi);
      if (angle == 0) {
        isBack = !isBack;
        Future.delayed(Duration(milliseconds: 300), () {
          if (!isBack) {
            currentBackIndex = (currentBackIndex % 20) + 1;

            if (currentBackIndex > playerCount) {
              currentBackIndex = 1;
              modifiedList = modifyList();
            }
          }
        });
      }
    });

    // After animation duration (500ms), reset the animation flag
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false;
      });
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
                  duration: Duration(milliseconds: 500),
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
                                      modifiedList[currentBackIndex - 1],
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
