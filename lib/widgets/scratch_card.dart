import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

import '../common/color_schemes.dart';
import '../common/strings.dart';
import '../services/reward_service.dart';
import 'popup_dialogs.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({
    super.key,
    this.addReward,
  });

  /// Callback function to add a reward to the player's unlocked rewards.
  final Function(int)? addReward;

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  /// Whether the game has ended.
  bool gameEnded = false;

  /// Whether the user won the game.
  bool userWon = false;

  /// List of reward ids to be displayed on the scratch card.
  List<int> rewardIds = <int>[];

  /// List of indices that the user has scratched.
  List<int> scratchedIndices = <int>[];

  /// The winning reward id.
  int winningRewardId = -1;

  /// List of keys for the scratch card items.
  List<GlobalKey<ScratcherState>> scratchKey = <GlobalKey<ScratcherState>>[];

  /// Whether the user has scratched all the items.
  bool get didUserScratchAllItems {
    return scratchedIndices.length == rewardIds.length;
  }

  /// Whether the user has scratched all the winning items.
  bool get didUserScratchWinningItems {
    return scratchedIndices.where((int index) {
          return rewardIds[index] == winningRewardId;
        }).length >=
        3;
  }

  /// Resets the scratch card.
  void _reset() {
    setState(() {
      gameEnded = false;
      userWon = false;
      rewardIds = <int>[];
      scratchedIndices = <int>[];
    });
    scratchKey = <GlobalKey<ScratcherState>>[];
    for (int i = 0; i < 9; i++) {
      scratchKey.add(GlobalKey<ScratcherState>());
    }
    _prepareRewards();
  }

  /// Prepares the list of rewards to be displayed.
  void _prepareRewards() {
    //Generate 9 random reward ids.
    rewardIds = RewardService.randomRewardIds(9);

    final bool shouldWin = Random().nextBool();
    //If the user should win, generate 3 random indices and replace the
    //reward ids at those indices with the winning reward id.
    if (shouldWin) {
      //Generate a random wining reward id that is not already in the List.
      winningRewardId = rewardIds[Random().nextInt(9)];

      final List<int> updatedIndices = <int>[
        rewardIds.indexOf(winningRewardId)
      ];
      for (int i = 0; i < 2; i++) {
        //Generate a random index that is not already in the list.
        int randomIndex = Random().nextInt(9);
        while (updatedIndices.contains(randomIndex)) {
          randomIndex = Random().nextInt(9);
        }

        //Update the reward id at the random index to be the winning reward id.
        updatedIndices.add(randomIndex);
        rewardIds[randomIndex] = winningRewardId;
      }

      userWon = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    Strings.scratchAndWin,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  if (gameEnded)
                    ElevatedButton(
                      onPressed: _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(Strings.reset),
                    ),
                ],
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
                        key: scratchKey[index],
                        accuracy: ScratchAccuracy.medium,
                        brushSize: 80,
                        threshold: 30,
                        rebuildOnResize: false,
                        color: Colors.grey[400]!,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              RewardService.rewardPathById(rewardIds[index]),
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        onScratchEnd: () {
                          if (userWon &&
                              didUserScratchWinningItems &&
                              !gameEnded) {
                            setState(() {
                              gameEnded = true;
                            });
                            Future<void>.delayed(
                                    const Duration(milliseconds: 500))
                                .then((_) {
                              widget.addReward!(winningRewardId);
                              CustomPopups().playerWonPopup(
                                context: context,
                                reward: Image.asset(
                                  RewardService.rewardPathById(winningRewardId),
                                ),
                              );
                            });
                          }
                          if (!userWon &&
                              didUserScratchAllItems &&
                              !gameEnded) {
                            setState(() {
                              gameEnded = true;
                            });
                            Future<void>.delayed(
                                    const Duration(milliseconds: 500))
                                .then(
                              (_) {
                                CustomPopups().youLostPopup(
                                  context: context,
                                  onGoBack: () {},
                                );
                              },
                            );
                          }
                        },
                        onThreshold: () {
                          scratchedIndices.add(index);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
