import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../screens/unlocked_rewards.dart';
import '../services/reward_service.dart';
import 'reward_thumbnail.dart';

/// A horizontal list of rewards, displaying the rewards that the player has
/// unlocked.
class RewardsBar extends StatelessWidget {
  const RewardsBar({
    super.key,
    required this.unlockedRewardIds,
  });

  /// The list of reward ids that the player has unlocked.
  final List<int> unlockedRewardIds;

  /// The scroll controller for the rewards bar.
  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Divider(),
        Row(
          children: <Widget>[
            Text(
              '${Strings.unlockedRewards}: ${unlockedRewardIds.length}/${RewardService().maxRewards}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => const UnlockedRewards(),
                  ),
                );
              },
              child: Text(
                Strings.viewRewards,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SizedBox(
              height: 80,
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemExtent: 80,
                children: <Widget>[
                  for (int i = 0; i < RewardService().maxRewards; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: RewardThumbnail(
                        unlocked: unlockedRewardIds.contains(i),
                        image: RewardService().rewardById(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
