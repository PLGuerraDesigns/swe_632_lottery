import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
import 'game_screen.dart';
import 'unlocked_rewards.dart';

class WheelOfFortuneGame extends StatelessWidget {
  const WheelOfFortuneGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        title: const Text(Strings.wheelOfFortune),
        centerTitle: false,
        actions: const <Widget>[
          ThemeModeButton(),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                Strings.wheelOfFortuneDescription,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              OutlinedButton(
                child: Text(
                  'HOW TO PLAY',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  CustomPopups().howToPlayPopup(
                      context: context,
                      description: 'Tap the spin button to spin the wheel.\n'
                          'You win the prize you land on!');
                },
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) =>
                          const UnlockedRewards(),
                    ),
                  );
                },
                child: Text(
                  'VIEW ALL REWARDS',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Flexible(
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
