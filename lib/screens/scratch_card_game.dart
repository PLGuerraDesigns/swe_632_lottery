import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/rewards_bar.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';
import 'unlocked_rewards.dart';

/// The Scratch Cards game screen.
class ScratchCardGame extends StatelessWidget {
  const ScratchCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
        return GameScreen(
          appBar: AppBar(
            title: const Text(Strings.scratchCards),
            centerTitle: false,
            actions: const <Widget>[
              ThemeModeButton(),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    Strings.getThreeOfTheSameItemToWin,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  OutlinedButton(
                    child: Text(
                      Strings.howToPlay.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      CustomPopups().howToPlayPopup(
                        context: context,
                        description: Strings.scratchTheCardHowToPlay,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ScratchCard(
                      player: player,
                    ),
                  ),
                ),
              ),
              RewardsBar(unlockedRewardIds: player.unlockedRewardIds),
            ],
          ),
        );
      },
    );
  }
}
