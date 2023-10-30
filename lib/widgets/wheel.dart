import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';

import '../common/color_schemes.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import 'popup_dialogs.dart';

class Wheel extends StatefulWidget {
  const Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  RewardService rewardService = RewardService();
  List<int> rewardList = <int>[];
  bool userSpun = false;
  late final StreamController<int> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>();
    _initRewardList();
  }

  void _initRewardList() {
    rewardList.clear();
    for (int i = 0; i < 12; i++) {
      rewardList.add(Random().nextInt(rewardService.maxRewards));
    }
  }

  Future<void> _spin(Player player) async {
    // Check if a spin is currently in progress
    if (userSpun) {
      return;
    }

    userSpun = true;
    final int value = Fortune.randomInt(0, 11);
    controller.add(value);

    await Future<void>.delayed(const Duration(milliseconds: 5250)).then(
      (_) {
        player.rewardIds.add(rewardList[value]);
        CustomPopups().playerWonPopup(
          context: context,
          reward: Image.asset(
            rewardService.rewardById(
              rewardList[value],
            ),
            width: 100,
            fit: BoxFit.contain,
          ),
          onGoBack: () {
            setState(() {
              _initRewardList();
              userSpun =
                  false; // Reset userSpun to allow the user to spin again
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
        builder: (BuildContext context, Player player, Widget? child) {
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
                      color: lightColorScheme.secondaryContainer,
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
                          child: Image.asset(
                            rewardService.rewardById(
                              rewardList[i],
                            ),
                            width: 65,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      style: FortuneItemStyle(
                        color: i.isEven
                            ? lightColorScheme.primary
                            : Colors.grey[400]!,
                      ),
                    ),
                ],
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _spin(player);
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
          ),
        ],
      );
    });
  }
}
