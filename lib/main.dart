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
        title: Text('Lucky Wheel'),
        centerTitle: true,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: FortuneWheel(
              items: [
                for (var controller in _itemControllers)
                  FortuneItem(child: Text(controller.text)),
              ],
              selected: _controller.stream,
              animateFirst: false,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.add(Random().nextInt(_numItems));
            },
            child: Text('Spin'),
          ),
        ],
      ),
    );
  }
}