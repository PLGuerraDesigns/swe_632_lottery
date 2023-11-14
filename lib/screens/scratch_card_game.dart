import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../widgets/coin_bank.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/rewards_bar.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

/// The Scratch Cards game screen.
class ScratchCardGame extends StatelessWidget {
  const ScratchCardGame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return GameScreen(
            compact: orientation == Orientation.portrait,
            appBar: AppBar(
              title: const Text(Strings.scratchCards),
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
                          description: Strings.scratchTheCardHowToPlay,
                        );
                      },
                    ),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      Strings.getThreeOfTheSameItemToWin,
                      style: orientation == Orientation.portrait
                          ? Theme.of(context).textTheme.titleLarge
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
                            description: Strings.scratchTheCardHowToPlay,
                          );
                        },
                      )
                  ],
                ),
                SizedBox(height: orientation == Orientation.portrait ? 12 : 20),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScratchCard(
                        addReward: player.addReward,
                      ),
                    ),
                  ),
                ),
                RewardsBar(
                  unlockedRewardIds: player.unlockedRewardIds,
                  playerCoins: player.coins,
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
