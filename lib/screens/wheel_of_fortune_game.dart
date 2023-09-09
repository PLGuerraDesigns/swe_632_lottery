import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/gmu_logo_background.dart';
import '../widgets/wheel.dart';

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                color: Theme.of(context).colorScheme.primary,
                child: Text('Spin the Wheel',
                    style: Theme.of(context).textTheme.headlineMedium),
                onPressed: () {},
              ),
            ),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Wheel(),
            )
          ],
        ),
      ),
    );
  }
}
