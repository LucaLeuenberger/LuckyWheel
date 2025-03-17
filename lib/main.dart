import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';

void main() {
  runApp(BossinfoLuckyWheel());
}

class BossinfoLuckyWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF004B87), // Bossinfo-Blau
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LuckyWheel(),
    );
  }
}

class LuckyWheel extends StatefulWidget {
  @override
  _LuckyWheelState createState() => _LuckyWheelState();
}

class _LuckyWheelState extends State<LuckyWheel> {
  final StreamController<int> _controller = StreamController<int>();
  final List<TextEditingController> _itemControllers = [];
  final List<FocusNode> _focusNodes = [];
  int _numItems = 5;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  void _initializeItems() {
    _itemControllers.clear();
    _focusNodes.clear();
    for (int i = 0; i < _numItems; i++) {
      final controller = TextEditingController(text: 'Prize ${i + 1}');
      controller.addListener(() {
        setState(() {});
      });
      _itemControllers.add(controller);
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    _controller.close();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004B87), // Bossinfo Blau
        centerTitle: true,
        title: Text(
          'Bossinfo Glücksrad',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Settings'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Number of Items'),
              subtitle: Slider(
                value: _numItems.toDouble(),
                min: 2,
                max: 20,
                divisions: 18,
                label: _numItems.toString(),
                onChanged: (value) {
                  setState(() {
                    _numItems = value.toInt();
                    _initializeItems();
                  });
                },
              ),
            ),
            for (int i = 0; i < _numItems; i++)
              ListTile(
                title: TextField(
                  controller: _itemControllers[i],
                  focusNode: _focusNodes[i],
                  decoration: InputDecoration(labelText: 'Item ${i + 1}'),
                  onTap: () {
                    _focusNodes[i].requestFocus();
                  },
                ),
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Hintergrundbild mit Transparenz
          Opacity(
            opacity:
                0.2, // Bild wird leicht transparent für einen sanften Effekt
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/wallpaper.png'), // Stelle sicher, dass das Bild im assets-Ordner liegt
                  fit: BoxFit.cover, // Bild füllt den gesamten Hintergrund
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: FortuneWheel(
                  items: [
                    for (var controller in _itemControllers)
                      FortuneItem(
                        child: Text(
                          controller.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black87, // Dunklerer Text für bessere Lesbarkeit
                          ),
                        ),
                        style: FortuneItemStyle(
                          color: Colors
                              .white, // Heller Hintergrund für besseren Kontrast
                          borderColor: Colors.blue, // Rand in Bossinfo-Blau
                          borderWidth: 3,
                        ),
                      ),
                  ],
                  selected: _controller.stream,
                  indicators: <FortuneIndicator>[
                    FortuneIndicator(
                      alignment: Alignment.topCenter,
                      child: TriangleIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor:
                      Color(0xFFFFA500), // Orange als Kontrastfarbe
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 10,
                ),
                onPressed: () {
                  _controller.add(Random().nextInt(_itemControllers.length));
                },
                child: Text(
                  '🎡 Drehen!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 50), // Platz für das Logo
              Image.asset(
                'assets/Bildbossinfo.png', // Logo bleibt unten in der Mitte
                height: 80, // Logo-Größe anpassen
              ),
            ],
          ),
        ],
      ),
    );
  }
}
