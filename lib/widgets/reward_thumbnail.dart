import 'dart:ui';

import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../services/reward_service.dart';
import 'frosted_container.dart';

/// A thumbnail for a reward.
///
/// Displays the reward image and a lock icon if the reward is locked.
class RewardThumbnail extends StatelessWidget {
  const RewardThumbnail({
    super.key,
    required this.rewardId,
    required this.unlocked,
    required this.onTap,
    required this.playerCoins,
    this.compact = false,
  });

  /// The ID of the reward.
  final int rewardId;

  /// Whether the reward is unlocked.
  final bool unlocked;

  /// Whether the thumbnail should be compact.
  final bool compact;

  /// The number of coins the player has.
  final int playerCoins;

  /// The function to call when the thumbnail is tapped.
  final Function() onTap;

  Widget _banner(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(compact ? 12 : 24),
        bottomRight: Radius.circular(compact ? 12 : 24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: compact ? 8.0 : 16.0,
                vertical: compact ? 4.0 : 8.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  Strings.coinAssetPath,
                  width: compact ? 12 : 24,
                  height: compact ? 12 : 24,
                ),
                SizedBox(width: compact ? 4 : 8),
                Text(
                  RewardService.rewardCost(rewardId).toString(),
                  style: compact
                      ? Theme.of(context).textTheme.bodySmall
                      : Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the tooltip text.
  String _tooltip() {
    return unlocked
        ? 'Unlocked'
        : playerCoins < RewardService.rewardCost(rewardId)
            ? '${RewardService.rewardCost(rewardId) - playerCoins} more coins needed to unlock.'
            : 'Unlock for ${RewardService.rewardCost(rewardId)} coins.';
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltip(),
      waitDuration: const Duration(milliseconds: 500),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            compact ? 12 : 24,
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: FrostedContainer(
          padding: EdgeInsets.zero,
          compact: compact,
          child: InkWell(
            onTap: unlocked
                ? null
                : () {
                    if (playerCoins >= RewardService.rewardCost(rewardId)) {
                      onTap.call();
                    } else {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: <Widget>[
                              const Text(
                                'You need',
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                Strings.coinAssetPath,
                                width: 16,
                                height: 16,
                              ),
                              Text(
                                ' ${RewardService.rewardCost(rewardId) - playerCoins} more to unlock this reward.',
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(compact ? 8.0 : 16.0),
                  child: Opacity(
                    opacity: unlocked ? 1 : 0.5,
                    child: Image.asset(
                      RewardService.rewardPathById(rewardId),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (!unlocked && !compact)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.lock,
                        size: compact ? 24 : 42,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.9),
                      ),
                    ),
                  ),
                if (!unlocked)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _banner(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
