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
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
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

      for (int indexToReplace in uniqueIndices.toList()) {
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

  String get currentBackImage => 'assets/Player-$currentBackIndex.png';

  void _flip() {
    if (isAnimating) return;

    setState(() {
      isAnimating = true;
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

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimating = false;
      });
    });
  }

  void _startNewGame() {
    setState(() {
      currentBackIndex = 1;
      modifiedList = modifyList();
      angle = 0;
      isBack = true;
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text("Settings", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Players',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                controller: TextEditingController(text: playerCount.toString()),
                onChanged: (value) {
                  playerCount = int.tryParse(value) ?? playerCount;
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Spies',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                controller: TextEditingController(text: spyCount.toString()),
                onChanged: (value) {
                  spyCount = int.tryParse(value) ?? spyCount;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Apply', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  modifiedList = modifyList();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Spy',
          style: TextStyle(
            fontFamily: 'TT-Bluescreens',
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
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
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                            offset: Offset(5.0, 5.0),
                                          ),
                                        ],
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _startNewGame,
                child: Text('New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Players: $playerCount | Spies: $spyCount',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
