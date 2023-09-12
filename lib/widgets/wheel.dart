import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../common/color_schemes.dart';
import '../services/RewardService.dart';
import 'popup_dialogs.dart';

class Wheel extends StatefulWidget {
  const Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  late final StreamController<int> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>();
  }

  void _spin() async {
    final int value = Fortune.randomInt(0, 12);
    controller.add(value);

    await Future<void>.delayed(const Duration(milliseconds: 5250)).then((_) {
      CustomPopups().youWonPopup(
          context: context, rewardPath: RewardService().rewardById(value));
    });
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
                          color: i.isEven
                              ? lightColorScheme.onError
                              : lightColorScheme.onInverseSurface,
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
            _spin();
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
