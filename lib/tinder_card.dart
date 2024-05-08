import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class tinderCard extends StatelessWidget {
  final color;

  tinderCard({required this.color});

  @override
  Widget build(BuildContext context) {
    return Swipable(
      child:  Container(
        color: color,
        ),
    );
  }
}