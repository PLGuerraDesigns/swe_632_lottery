import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../common/color_schemes.dart';

class Wheel extends StatefulWidget {
  const Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late final StreamController<int> controller;

  Timer? _spinTimer;
  Timer? _stopTimer;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>();
  }

  void _startSpinning() {
    // Avoid starting if already spinning
    if (_spinTimer != null) {
      return;
    }

    _spinTimer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      controller.add(Fortune.randomInt(0, 3)); // Cycle between 0, 1, 2
    });

    _stopTimer = Timer(const Duration(seconds: 5), () {
      _stopSpinning();
    });
  }

  void _stopSpinning() {
    _spinTimer?.cancel();
    _spinTimer = null;
    _stopTimer?.cancel();
    _stopTimer = null;
  }

  @override
  void dispose() {
    controller.close();
    _spinTimer?.cancel();
    _stopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FortuneWheel(
              indicators: <FortuneIndicator>[
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              ],
              selected: controller.stream,
              animateFirst: false,
              items: <FortuneItem>[
                for (int i = 0; i < 12; i++)
                  FortuneItem(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Icon(
                          Icons.question_mark,
                          color: i.isOdd
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: i.isEven
                          ? lightColorScheme.error
                          : lightColorScheme.inverseSurface,
                    ),
                  ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _startSpinning();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'SPIN',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
