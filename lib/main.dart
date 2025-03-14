import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LuckyWheel(),
    );
  }
}

class LuckyWheel extends StatefulWidget {
  @override
  _LuckyWheelState createState() => _LuckyWheelState();
}

class _LuckyWheelState extends State<LuckyWheel> {
  final List<String> items = ['Prize 1', 'Prize 2', 'Prize 3', 'Prize 4', 'Prize 5'];
  final StreamController<int> _controller = StreamController<int>();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lucky Wheel'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: FortuneWheel(
              items: [
                for (var item in items) FortuneItem(child: Text(item)),
              ],
              selected: _controller.stream,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.add(Random().nextInt(items.length));
            },
            child: Text('Spin'),
          ),
        ],
      ),
    );
  }
}