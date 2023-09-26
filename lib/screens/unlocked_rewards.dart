import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../services/reward_service.dart';
import '../widgets/frosted_container.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

class UnlockedRewards extends StatelessWidget {
  const UnlockedRewards({super.key});

  Widget _reward({
    required BuildContext context,
    required String name,
    required String image,
    required bool unlocked,
  }) {
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
                child: Icon(
                  Icons.lock,
                  size: 50,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text('Rewards'),
        actions: const <Widget>[
          ThemeModeButton(),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Play games to unlock rewards!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Consumer<Player>(
              builder: (BuildContext context, Player player, Widget? child) {
            return Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  for (int i = 0; i < RewardService().maxRewards; i++)
                    _reward(
                      context: context,
                      name: 'Reward $i',
                      unlocked: player.rewardIds.contains(i),
                      image: RewardService().rewardById(i),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
