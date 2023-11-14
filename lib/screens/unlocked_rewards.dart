import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import '../widgets/coin_bank.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/reward_thumbnail.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

/// The Unlocked Rewards screen.
class UnlockedRewards extends StatelessWidget {
  const UnlockedRewards({super.key});

  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return GameScreen(
          compact: orientation == Orientation.portrait,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: const Text(Strings.unlockedRewards),
            actions: const <Widget>[
              CoinBank(),
              SizedBox(width: 16),
              ThemeModeButton(),
            ],
          ),
          child: Consumer<Player>(
            builder: (BuildContext context, Player player, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Strings.playGamesToUnlockRewards,
                          style: orientation == Orientation.portrait
                              ? Theme.of(context).textTheme.titleLarge
                              : Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${player.unlockedRewardIds.length}/${RewardService.maxRewards}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: orientation == Orientation.portrait ? 12 : 20),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: GridView.count(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        controller: _scrollController,
                        padding: orientation == Orientation.portrait
                            ? const EdgeInsets.only(right: 16)
                            : const EdgeInsets.symmetric(horizontal: 20),
                        children: <Widget>[
                          for (int i = 0; i < RewardService.maxRewards; i++)
                            RewardThumbnail(
                              rewardId: i,
                              unlocked: player.unlockedRewardIds.contains(i),
                              playerCoins: player.coins,
                              onTap: () {
                                CustomPopups().confirmUnlockReward(
                                  context: context,
                                  rewardId: i,
                                  onConfirm: () => player.buyReward(i),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ));
    });
  }
}
