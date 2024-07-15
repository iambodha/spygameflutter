import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int cardIndex = 0;
  final int numberOfCards = 34;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _nextCard() {
    _animationController.forward(from: 0).then((_) {
      setState(() {
        cardIndex = (cardIndex + 1) % numberOfCards;
      });
      cardKey.currentState?.toggleCard();
      _animationController.reset();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              Stack(
                children: [
                  FlipCard(
                    key: cardKey,
                    flipOnTouch: false,
                    front: Container(
                      width: 309,
                      height: 474,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/back.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    back: Container(
                      width: 309,
                      height: 474,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/face.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Surprise ! 🎊",
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(309, 474),
                        painter: GlassBreakPainter(_animation.value),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextCard,
                child: Text("Flip Card"),
              ),
              SizedBox(height: 20),
              Text(
                "Card ${cardIndex + 1} of $numberOfCards",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassBreakPainter extends CustomPainter {
  final double progress;
  final List<GlassShard> shards = List.generate(50, (_) => GlassShard());

  GlassBreakPainter(this.progress) {
    for (var shard in shards) {
      shard.update(progress);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var shard in shards) {
      final path = Path()
        ..moveTo(shard.x, shard.y)
        ..lineTo(shard.x + shard.width * cos(shard.angle),
            shard.y + shard.width * sin(shard.angle))
        ..lineTo(
            shard.x +
                shard.width * cos(shard.angle) -
                shard.height * sin(shard.angle),
            shard.y +
                shard.width * sin(shard.angle) +
                shard.height * cos(shard.angle))
        ..lineTo(shard.x - shard.height * sin(shard.angle),
            shard.y + shard.height * cos(shard.angle))
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GlassShard {
  late double x, y, width, height, angle, speed, direction;

  GlassShard() {
    final random = Random();
    x = random.nextDouble() * 309;
    y = random.nextDouble() * 474;
    width = random.nextDouble() * 20 + 5;
    height = random.nextDouble() * 20 + 5;
    angle = random.nextDouble() * 2 * pi;
    speed = random.nextDouble() * 5 + 2;
    direction = random.nextDouble() * 2 * pi;
  }

  void update(double progress) {
    x += cos(direction) * speed * progress;
    y += sin(direction) * speed * progress;
    angle += 0.1 * progress;
  }
}
