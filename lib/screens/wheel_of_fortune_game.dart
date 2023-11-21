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
  void initState() {
    super.initState();
    Provider.of<Player>(context, listen: false).resetRewardController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return GameScreen(
            rewardIdController: player.rewardIdController,
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
                    if (orientation == Orientation.portrait) const Spacer(),
                    Text(
                      Strings.wheelOfFortuneDescription,
                      style: orientation == Orientation.portrait
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.headlineMedium,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wheel(
                      onGameEnd: (int? rewardId) {
                        player.incrementNumberOfWheelOfFortuneGamesPlayed();
                        if (rewardId == null) {
                          return;
                        }
                        player.addRewardFromWheelOfFortune(rewardId);
                      },
                    ),
                  ),
                ),
                RewardsBar(
                  unlockedRewardIds: player.unlockedRewardIds,
                  resetAnimationController: player.resetRewardController,
                  playerCoins: player.coins,
                  returnScreenFromUnlockedRewards: const WheelOfFortuneGame(),
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
