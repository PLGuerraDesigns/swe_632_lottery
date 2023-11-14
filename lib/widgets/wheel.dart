import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../common/color_schemes.dart';
import '../common/strings.dart';
import '../services/reward_service.dart';
import 'popup_dialogs.dart';

class Wheel extends StatefulWidget {
  const Wheel({
    super.key,
    this.addReward,
  });

  /// Callback function to add a reward to the player's unlocked rewards.
  final Function(int)? addReward;

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  /// List of reward ids to be displayed on the wheel.
  List<int> rewardIds = <int>[];

  /// Whether the wheel is currently spinning.
  bool isSpinning = false;

  /// Controller for the wheel animation.
  late final StreamController<int> controller;

  /// Shuffles the rewards on the wheel.
  void _shufflePrizes() {
    rewardIds = RewardService.randomRewardIds(12);
  }

  /// Spins the wheel.
  Future<void> _spin() async {
    // Check if a spin is currently in progress
    if (isSpinning) {
      return;
    }
    isSpinning = true;

    // Generate a random value and add it to the controller and
    // start the animation
    final int value = Fortune.randomInt(0, 11);
    controller.add(value);

    // Wait for the animation to finish and then show the reward popup
    await Future<void>.delayed(const Duration(milliseconds: 3750)).then(
      (_) {
        widget.addReward!(rewardIds[value]);
        setState(() {
          isSpinning = false;
        });
        CustomPopups().playerWonPopup(
          context: context,
          reward: Image.asset(
            RewardService.rewardPathById(rewardIds[value]),
            width: 100,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller = StreamController<int>();
    // Set the initial rewards
    _shufflePrizes();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
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
                duration: const Duration(milliseconds: 3500),
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
                onFling: () {
                  _spin();
                },
                items: <FortuneItem>[
                  for (int i = 0; i < 12; i++)
                    FortuneItem(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Image.asset(
                              RewardService.rewardPathById(rewardIds[i]),
                              width: 65,
                              height: 65,
                              fit: BoxFit.contain,
                            ),
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
                        Strings.spin,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(70, 30),
                visualDensity: VisualDensity.compact,
                backgroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                setState(() {
                  _shufflePrizes();
                });
              },
              child: Text(
                Strings.shufflePrizes.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
