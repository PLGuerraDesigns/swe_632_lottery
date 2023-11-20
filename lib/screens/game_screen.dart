import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/frosted_container.dart';
import '../widgets/gmu_logo_background.dart';
import '../widgets/unlock_reward_animation.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.child,
    this.rewardIdController,
    this.header,
    this.appBar,
    this.compact = false,
    this.onExit,
  });

  /// The controller for the reward animation.
  final StreamController<int>? rewardIdController;

  /// The app bar to display at the top of the screen.
  final AppBar? appBar;

  /// The widget to display at the top.
  final Widget? header;

  /// The widget to display in the center of the screen.
  final Widget child;

  /// Whether the screen is in compact mode.
  final bool compact;

  /// The function to call when the page is exited.
  final Function()? onExit;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: GMUBackground(
        compact: widget.compact,
        child: RewardAnimation(
          rewardController: widget.rewardIdController,
          onPageExit: widget.onExit,
          screen: Padding(
            padding: EdgeInsets.all(widget.compact ? 12 : 20),
            child: FrostedContainer(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.header != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: widget.header,
                  ),
                Expanded(
                  child: widget.child,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
