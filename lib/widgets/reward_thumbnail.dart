import 'package:flutter/material.dart';

import 'frosted_container.dart';

/// A thumbnail for a reward.
///
/// Displays the reward image and a lock icon if the reward is locked.
class RewardThumbnail extends StatelessWidget {
  const RewardThumbnail({
    super.key,
    required this.image,
    required this.unlocked,
  });

  /// The image to display in the thumbnail.
  final String image;

  /// Whether the reward is unlocked.
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(24),
      ),
      child: FrostedContainer(
        padding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Opacity(
                opacity: unlocked ? 1 : 0.25,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (!unlocked)
              FrostedContainer(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.lock,
                  size: 35,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
