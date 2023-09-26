import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';
import 'unlocked_rewards.dart';

class ScratchCardGame extends StatelessWidget {
  const ScratchCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        title: const Text(Strings.scratchCards),
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
                'Get 3 of the same item to win!',
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
                      description: 'Scratch the card to reveal the items.\n'
                          'If you get 3 or more of the same item, you win!');
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
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ScratchCard(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
