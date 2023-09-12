import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratcher/scratcher.dart';

import '../common/color_schemes.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import 'popup_dialogs.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({super.key});

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  bool userWon = false;

  RewardService rewardService = RewardService();
  List<int> rewardIds = <int>[];
  List<int> scratchedIds = <int>[];

  bool get didUserScratchAllItems {
    return scratchedIds.length == rewardIds.length;
  }

  bool get didUserScratchWinningItems {
    return scratchedIds.toSet().intersection(rewardIds.toSet()).isNotEmpty;
  }

  void reset() {
    setState(() {
      userWon = false;
      rewardIds = <int>[];
      scratchedIds = <int>[];
    });
    _prepareRewards();
  }

  @override
  void initState() {
    super.initState();
    _prepareRewards();
  }

  /// Prepares the list of rewards to be displayed.
  void _prepareRewards() {
    final List<int> itemIds = <int>[];
    bool empty;
    int count = 0;

    for (int i = 0; i < 9; i++) {
      empty = Random().nextBool();

      if (empty) {
        rewardIds.add(-1);
      } else {
        final int randomId = Random().nextInt(rewardService.maxRewards);
        rewardIds.add(randomId);

        /// Loop through all items and see if the random item is already in the list.
        for (int j = 0; j < itemIds.length; j++) {
          /// If the random item is already in the list, increment the count.
          if (randomId == itemIds[j]) {
            count++;
          }

          /// If the random item is already in the list twice, print a message.
          if (count >= 3) {
            userWon = true;
          }
        }
        itemIds.add(randomId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
        builder: (BuildContext context, Player player, Widget? child) {
      return Container(
        width: 350,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'SCRATCH AND WIN!',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: lightColorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: 9,
                      itemBuilder: (BuildContext context, int index) {
                        return Scratcher(
                          key: GlobalKey(),
                          brushSize: 50,
                          threshold: 30,
                          color: Colors.grey[400]!,
                          child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.expand,
                            children: <Widget>[
                              if (rewardIds[index] != -1)
                                Image.asset(
                                  rewardService.rewardById(rewardIds[index]),
                                  fit: BoxFit.contain,
                                ),
                            ],
                          ),
                          onScratchEnd: () {
                            if (userWon && didUserScratchWinningItems) {
                              Future<void>.delayed(
                                      const Duration(milliseconds: 500))
                                  .then((_) {
                                player.rewardIds.add(rewardIds[index]);
                                CustomPopups().playerWonPopup(
                                  context: context,
                                  reward: Image.asset(
                                    RewardService()
                                        .rewardById(rewardIds[index]),
                                  ),
                                  onPlayAgain: reset,
                                );
                              });
                            }
                            if (!userWon && didUserScratchAllItems) {
                              Future<void>.delayed(
                                      const Duration(milliseconds: 500))
                                  .then(
                                (_) {
                                  CustomPopups().youLostPopup(
                                    context: context,
                                    onPlayAgain: reset,
                                  );
                                },
                              );
                            }
                          },
                          onThreshold: () {
                            scratchedIds.add(rewardIds[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Good luck!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
