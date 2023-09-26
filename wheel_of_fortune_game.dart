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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.wallet_giftcard),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) => const UnlockedRewards(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              CustomPopups().howToPlayPopup(
                context: context,
                description: 'Tap the spin button to spin the wheel.\n'
                    'If you land on a prize, you win!',
              );
            },
            icon: const Icon(Icons.help),
          ),
          const ThemeModeButton(),
        ],
      ),
      description: Strings.wheelOfFortuneDescription,
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Wheel(),
      ),
    );
  }
}
