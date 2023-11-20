import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../common/color_schemes.dart';
import '../services/reward_service.dart';

/// Overlays a reward animation on top of the screen.
class RewardAnimation extends StatefulWidget {
  const RewardAnimation({
    super.key,
    this.rewardController,
    required this.onPageExit,
    required this.screen,
  });

  /// The stream controller for the reward animation.
  final StreamController<int>? rewardController;

  /// The screen to overlay the animation on.
  final Widget screen;

  /// Callback function to call when the page is exited.
  final void Function()? onPageExit;

  @override
  State<RewardAnimation> createState() => RewardAnimationState();
}

class RewardAnimationState extends State<RewardAnimation> {
  /// The controller for the confetti animation.
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  /// The id of the reward to display.
  int _rewardId = -5;

  /// The opacity of the reward image.
  double _opacity = 0.0;

  /// The transform of the reward image.
  Matrix4 _transform = Matrix4.identity()
    ..translate(90, 45)
    ..scale(0.1);

  /// The colors of the confetti.
  final List<Color> _confettiColors = [
    lightColorScheme.primary,
    darkColorScheme.secondary,
    Colors.pink,
  ];

  /// Animates the reward animation.
  Future<void> _animate() async {
    Future<void>.delayed(const Duration(milliseconds: 80)).then((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    _confettiController.play();

    setState(() {
      _transform = Matrix4.identity()
        ..translate(-60, -110)
        ..scale(1.6);
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    await Future<void>.delayed(const Duration(milliseconds: 700)).then((_) {
      setState(() {
        if (_rewardId < 0) {
          _transform = Matrix4.identity()
            ..translate(MediaQuery.of(context).size.width / 2 - 10,
                -MediaQuery.of(context).size.height / 2 + 10)
            ..scale(0.1);
        } else {
          _transform = Matrix4.identity()
            ..translate(-MediaQuery.of(context).size.width / 2 + 180,
                MediaQuery.of(context).size.height / 2 - 80)
            ..scale(0.3);
        }
      });
    });

    await Future<void>.delayed(const Duration(milliseconds: 100)).then((_) {
      setState(() {
        _opacity = 0.0;
      });
    });

    await Future<void>.delayed(const Duration(milliseconds: 500)).then((_) {
      setState(() {
        _transform = Matrix4.identity()
          ..translate(90, 45)
          ..scale(0.1);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    widget.rewardController?.stream.listen((int? rewardId) {
      if (rewardId == null || rewardId == -1) {
        return;
      }
      _rewardId = rewardId;
      _animate();
    });
  }

  @override
  void dispose() {
    widget.onPageExit?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        widget.screen,
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi * 0.75,
            particleDrag: 0.01,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            colors: _confettiColors,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi * 0.25,
            particleDrag: 0.01,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            colors: _confettiColors,
          ),
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 750),
          transform: _transform,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _opacity,
            child: Image.asset(
              RewardService.rewardPathById(_rewardId),
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
