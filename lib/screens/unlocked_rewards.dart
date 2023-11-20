import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/enums.dart';
import '../common/strings.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import '../widgets/coin_bank.dart';
import '../widgets/filter_button.dart';
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
        return Consumer<Player>(
          builder: (BuildContext context, Player player, Widget? child) {
            return GameScreen(
              rewardIdController: player.rewardIdController,
              onExit: player.resetRewardController,
              scaleAnimationOnly: true,
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
              child: Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FilterButton(
                        onPressed: (String? value) {
                          if (value == null) {
                            return;
                          }
                          player.rewardFilterType = RewardFilterType.values
                              .firstWhere((RewardFilterType type) =>
                                  type.stringFromEnum == value);
                        },
                        icon: Icons.filter_alt,
                        label: player.rewardFilterType.stringFromEnum,
                        options: RewardFilterType.values
                            .map((RewardFilterType type) {
                          return type.stringFromEnum;
                        }).toList(),
                        tooltip: Strings.filterRewards,
                      ),
                      const SizedBox(width: 8),
                      FilterButton(
                        onPressed: (String? value) {
                          if (value == null) {
                            return;
                          }
                          player.rewardSortType = RewardSortType.values
                              .firstWhere((RewardSortType type) =>
                                  type.stringFromEnum == value);
                        },
                        icon: Icons.sort,
                        label: player.rewardSortType.stringFromEnum,
                        options:
                            player.rewardFilterType == RewardFilterType.locked
                                ? <String>[
                                    RewardSortType.lowestCost.stringFromEnum,
                                    RewardSortType.highestCost.stringFromEnum,
                                  ]
                                : <String>[
                                    RewardSortType.newest.stringFromEnum,
                                    RewardSortType.oldest.stringFromEnum,
                                  ],
                        tooltip: Strings.sortRewards,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  SizedBox(
                      height: orientation == Orientation.portrait ? 8 : 20),
                  if (player.unlockedRewardIds.isEmpty &&
                      player.rewardFilterType == RewardFilterType.unlocked)
                    Expanded(
                      child: Center(
                        child: Text(
                          Strings.noRewards,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  if (player.unlockedRewardIds.isEmpty &&
                      player.rewardFilterType != RewardFilterType.unlocked)
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: GridView.count(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            controller: _scrollController,
                            padding: orientation == Orientation.portrait
                                ? const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8)
                                : const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                            children: <Widget>[
                              for (final int id in RewardService.rewardIds(
                                sortType: player.rewardSortType,
                                filterType: player.rewardFilterType,
                                unlockedRewardIds: player.unlockedRewardIds,
                              ))
                                RewardThumbnail(
                                  rewardId: id,
                                  unlocked:
                                      player.unlockedRewardIds.contains(id),
                                  playerCoins: player.coins,
                                  onTap: () {
                                    CustomPopups().confirmUnlockReward(
                                      context: context,
                                      rewardId: id,
                                      onConfirm: () => player.buyReward(id),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
