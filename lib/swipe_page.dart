/*import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ai_dating/tinder_card.dart';

class Swipes extends StatefulWidget {
  const Swipes({Key? key}) : super(key: key);

  @override
  State<Swipes> createState() => _SwipesState();
}

class _SwipesState extends State<Swipes> {
  List<Color> _randomColors = [];

  @override
  void initState() {
    super.initState();
    _generateRandomColors();
  }

  void _generateRandomColors() {
    final Random random = Random();
    _randomColors = List.generate(3, (_) {
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 200,
          child: Stack(
            children: _randomColors.map((color) {
              return tinderCard(color: color);
            }).toList(),
          ),
        ),
      ),
    );
  }
}*/