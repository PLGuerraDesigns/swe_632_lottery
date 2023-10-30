import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

import '../common/color_schemes.dart';
import '../common/strings.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import 'popup_dialogs.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({super.key, this.player});

  final Player? player;
  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  bool userWon = false;
  bool gameEnded = false;

  RewardService rewardService = RewardService();
  List<int> rewardIds = <int>[];
  List<int> scratchedIndices = <int>[];
  int winningRewardId = -1;
  List<GlobalKey<ScratcherState>> scratchKey = <GlobalKey<ScratcherState>>[];

  bool get didUserScratchAllItems {
    return scratchedIndices.length == rewardIds.length;
  }

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

  @override
  void initState() {
    super.initState();
    _reset();
  }

  /// Prepares the list of rewards to be displayed.
  void _prepareRewards() {
    int randomId = -1;
    //1 in 2 chance of winning.
    final bool shouldWin = Random().nextBool();

    //Generate 9 random reward ids.
    for (int i = 0; i < 9; i++) {
      while (randomId == -1 || rewardIds.contains(randomId)) {
        randomId = Random().nextInt(rewardService.maxRewards);
      }
      rewardIds.add(randomId);
    }
    //If the user should win, generate 3 random indices and replace the
    //reward ids at those indices with the winning reward id.

    if (shouldWin) {
      //Generate a random wining reward id that is not already in the List.
      winningRewardId = Random().nextInt(rewardService.maxRewards);
      while (rewardIds.contains(winningRewardId)) {
        winningRewardId = Random().nextInt(rewardService.maxRewards);
      }

      final List<int> updatedIndices = <int>[];
      for (int i = 0; i < 3; i++) {
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
                              rewardService.rewardById(rewardIds[index]),
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
                              widget.player?.addReward(winningRewardId);
                              CustomPopups().playerWonPopup(
                                context: context,
                                reward: Image.asset(
                                  RewardService().rewardById(winningRewardId),
                                ),
                                onGoBack: () {},
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
