import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../widgets/wheel.dart';
import 'game_screen.dart';

class WheelOfFortuneGame extends StatelessWidget {
  const WheelOfFortuneGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        title: const Text(Strings.wheelOfFortune),
        centerTitle: false,
      ),
      description: Strings.wheelOfFortuneDescription,
      child: const Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Wheel(),
            ),
          ),
        ],
      ),
    );
  }
}
