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
                  description: 'Scratch the card to reveal the items.\n'
                      'If you get 3 or more of the same item, you win!');
            },
            icon: const Icon(Icons.help),
          ),
          const ThemeModeButton(),
        ],
      ),
      description: 'Get 3 of the same item to win!',
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ScratchCard(),
        ),
      ),
    );
  }
}
