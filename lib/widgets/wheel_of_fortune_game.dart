import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/gmu_logo_background.dart';
import '../widgets/wheel_new.dart';

class WheelOfFortuneGame extends StatelessWidget {
  WheelOfFortuneGame({super.key});
  final StreamController<int> controller = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wheel of Fortune'),
      ),
      body: GMUBackground(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.2), // Adjust the multiplier value as needed

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Wheel(),
            )
          ],
        ),
      ),
    );
  }
}
