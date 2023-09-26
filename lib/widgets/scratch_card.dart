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
  const ScratchCard({
    super.key,
  });

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

  bool get didUserScratchAllItems {
    return scratchedIndices.length == rewardIds.length;
  }

  bool get didUserScratchWinningItems {
    return scratchedIndices.where((int index) {
          return rewardIds[index] == winningRewardId;
        }).length >=
        3;
  }

  void reset() {
    setState(() {
      gameEnded = false;
      userWon = false;
      rewardIds = <int>[];
      scratchedIndices = <int>[];
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
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
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
                            if (userWon &&
                                didUserScratchWinningItems &&
                                !gameEnded) {
                              gameEnded = true;
                              Future<void>.delayed(
                                      const Duration(milliseconds: 500))
                                  .then((_) {
                                player.rewardIds.add(winningRewardId);
                                CustomPopups().playerWonPopup(
                                  context: context,
                                  reward: Image.asset(
                                    RewardService().rewardById(winningRewardId),
                                  ),
                                  onPlayAgain: reset,
                                );
                              });
                            }
                            if (!userWon &&
                                didUserScratchAllItems &&
                                !gameEnded) {
                              gameEnded = true;
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
                            scratchedIndices.add(index);
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
