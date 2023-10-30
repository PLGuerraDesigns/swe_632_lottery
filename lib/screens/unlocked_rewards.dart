import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import '../widgets/reward_thumbnail.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

/// The Unlocked Rewards screen.
class UnlockedRewards extends StatelessWidget {
  const UnlockedRewards({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(Strings.unlockedRewards),
        actions: const <Widget>[
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
                  Text(
                    Strings.playGamesToUnlockRewards,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  Text(
                    '${player.unlockedRewardIds.length}/${RewardService().maxRewards}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    for (int i = 0; i < RewardService().maxRewards; i++)
                      RewardThumbnail(
                        unlocked: player.unlockedRewardIds.contains(i),
                        image: RewardService().rewardById(i),
                      ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
