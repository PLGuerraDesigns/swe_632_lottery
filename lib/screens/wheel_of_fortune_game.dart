import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../widgets/coin_bank.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/rewards_bar.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
import 'game_screen.dart';

/// The Wheel of Fortune game screen.
class WheelOfFortuneGame extends StatefulWidget {
  const WheelOfFortuneGame({super.key});

  @override
  State<WheelOfFortuneGame> createState() => _WheelOfFortuneGameState();
}

class _WheelOfFortuneGameState extends State<WheelOfFortuneGame> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return GameScreen(
            rewardIdController: player.rewardIdController,
            onExit: player.resetRewardController,
            compact: orientation == Orientation.portrait,
            appBar: AppBar(
              title: const Text(Strings.wheelOfFortune),
              centerTitle: false,
              actions: const <Widget>[
                CoinBank(),
                SizedBox(width: 16),
                ThemeModeButton(),
              ],
            ),
            header: orientation == Orientation.landscape
                ? null
                : Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        Strings.howToPlay.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () {
                        CustomPopups().howToPlayPopup(
                          context: context,
                          description: Strings.wheelOfFortuneHowToPlay,
                        );
                      },
                    ),
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
                    if (orientation == Orientation.landscape)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
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
                SizedBox(height: orientation == Orientation.portrait ? 12 : 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wheel(
                      onGameEnd: (int? rewardId) {
                        if (rewardId == null) {
                          return;
                        }
                        player.addReward(rewardId);
                      },
                    ),
                  ),
                ),
                RewardsBar(
                  unlockedRewardIds: player.unlockedRewardIds,
                  playerCoins: player.coins,
                  onViewRewards: player.resetRewardController,
                  onRewardTap: (int rewardId) {
                    CustomPopups().confirmUnlockReward(
                      context: context,
                      rewardId: rewardId,
                      onConfirm: () => player.buyReward(rewardId),
                    );
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
