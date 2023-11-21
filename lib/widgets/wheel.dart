import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shimmer/shimmer.dart';

import '../common/color_schemes.dart';
import '../common/strings.dart';
import '../services/reward_service.dart';
import 'hover_scale_handler.dart';

/// The Wheel of Fortune game widget.
class Wheel extends StatefulWidget {
  const Wheel({
    super.key,
    this.onGameEnd,
  });

  /// Callback function to add a reward to the player's unlocked rewards.
  final Function(int)? onGameEnd;

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  /// The reward ids on the wheel.
  late List<int> _rewardIds;

  /// The controller for the wheel.
  late StreamController<int> _wheelController;

  /// Whether the wheel is currently spinning.
  bool _isSpinning = false;

  /// Shuffles the rewards on the wheel.
  void _shufflePrizes() {
    setState(() {
      _rewardIds = RewardService.randomRewardIds(12, coinBias: true);
    });
  }

  /// Spins the wheel.
  Future<void> _spin() async {
    // Check if a spin is currently in progress
    if (_isSpinning) {
      return;
    }
    setState(() {
      _isSpinning = true;
    });

    // Generate a random value and add it to the controller and
    // start the animation
    final int value = Fortune.randomInt(0, 11);
    _wheelController.add(value);

    await Future<void>.delayed(const Duration(milliseconds: 3500)).then((_) {
      setState(() {
        _isSpinning = false;
      });
      widget.onGameEnd!.call(_rewardIds[value]);
    });
  }

  @override
  void initState() {
    super.initState();
    // Generate the reward ids
    _rewardIds = RewardService.randomRewardIds(12, coinBias: true);
    // Initialize the controller
    _wheelController = StreamController<int>.broadcast();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: 500,
        width: 500,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(-5, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FortuneWheel(
                    rotationCount: 25,
                    indicators: <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: lightColorScheme.secondaryContainer,
                        ),
                      ),
                    ],
                    selected: _wheelController.stream,
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
                                  RewardService.rewardPathById(_rewardIds[i]),
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
            ),
            HoverScaleHandler(
              onTap: _spin,
              enabled: !_isSpinning,
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
                      padding: const EdgeInsets.all(24),
                      child: Shimmer.fromColors(
                        period: const Duration(milliseconds: 5000),
                        baseColor: Theme.of(context).colorScheme.onPrimary,
                        highlightColor: Color.alphaBlend(
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(
                          Strings.spin,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
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
              child: HoverScaleHandler(
                onTap: _shufflePrizes,
                enabled: !_isSpinning,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: Shimmer.fromColors(
                    period: const Duration(milliseconds: 5000),
                    baseColor: Theme.of(context).colorScheme.onPrimary,
                    highlightColor: Color.alphaBlend(
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      child: Text(
                        Strings.shufflePrizes.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
