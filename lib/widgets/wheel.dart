import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Wheel extends StatefulWidget {
  Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late final StreamController<int> controller = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return FortuneWheel(
      selected: controller.stream,
      curve: Curves.bounceOut,
      items: [
        FortuneItem(
            child: Image.network(
          'https://picsum.photos/250?image=9',
          height: 100,
        )),
        FortuneItem(
            child: Image.network(
          'https://picsum.photos/250?image=9',
          height: 100,
        )),
        FortuneItem(
            child: Image.network(
          'https://picsum.photos/250?image=9',
          height: 100,
        )),
      ],
    );
  }
}
