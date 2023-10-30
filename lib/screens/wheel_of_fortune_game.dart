import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/rewards_bar.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
import 'game_screen.dart';

/// The Wheel of Fortune game screen.
class WheelOfFortuneGame extends StatelessWidget {
  const WheelOfFortuneGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
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
                      Strings.howToPlay.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: () {
                      CustomPopups().howToPlayPopup(
                          context: context,
                          description: Strings.wheelOfFortuneHowToPlay);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wheel(
                    player: player,
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
