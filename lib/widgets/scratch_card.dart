import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shimmer/shimmer.dart';

import '../common/color_schemes.dart';
import '../common/strings.dart';
import '../services/reward_service.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({
    super.key,
    this.onGameEnd,
    this.gameEnded = false,
  });

  /// Callback for when the user finishes the game.
  final Function(int?)? onGameEnd;

  /// Whether the game has ended.
  final bool gameEnded;

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  /// Whether the game has started.
  bool gameStarted = false;

  /// Whether the user won the game.
  bool userWon = false;

  /// List of reward ids to be displayed on the scratch card.
  List<int> rewardIds = <int>[];

  /// List of indices that the user has scratched.
  List<int> scratchedIndices = <int>[];

  /// The winning reward id.
  int winningRewardId = -1;

  /// Whether to lower the opacity of the bait rewards.
  bool _fadeBaitRewards = false;

  /// List of keys for the scratch card items.
  List<GlobalKey<ScratcherState>> scratchKeys = <GlobalKey<ScratcherState>>[];

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
      gameStarted = false;
      _fadeBaitRewards = false;
      userWon = false;
      rewardIds = <int>[];
      scratchedIndices = <int>[];
    });
    scratchKeys = <GlobalKey<ScratcherState>>[];
    for (int i = 0; i < 9; i++) {
      scratchKeys.add(GlobalKey<ScratcherState>());
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

  /// Callback function for when the user finishes scratching an item.
  void _onScratchEnd() {
    if (userWon && didUserScratchWinningItems && !widget.gameEnded) {
      scratchKeys.forEach((GlobalKey<ScratcherState> key) {
        key.currentState!.reveal(
          duration: const Duration(milliseconds: 250),
        );
      });
      setState(() {
        if (userWon) {
          _fadeBaitRewards = true;
        }
      });
      widget.onGameEnd!(winningRewardId);
    }
    if (!userWon && didUserScratchAllItems && !widget.gameEnded) {
      widget.onGameEnd!(null);
      scratchKeys.forEach((GlobalKey<ScratcherState> key) {
        key.currentState!.reveal(
          duration: const Duration(milliseconds: 250),
        );
      });
    }
  }

  /// The grid of scratch items.
  Widget _scratchPad() {
    final Widget pad = GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      shrinkWrap: true,
      itemCount: 9,
      itemBuilder: (BuildContext context, int index) {
        return MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: GestureDetector(
            onTap: () {
              if (!gameStarted) {
                setState(() {
                  gameStarted = true;
                });
              }
              scratchKeys[index].currentState!.reveal(
                    duration: const Duration(milliseconds: 500),
                  );
              if (!scratchedIndices.contains(index)) {
                scratchedIndices.add(index);
              }
              _onScratchEnd();
            },
            child: Scratcher(
              key: scratchKeys[index],
              accuracy: ScratchAccuracy.medium,
              brushSize: 80,
              threshold: 30,
              rebuildOnResize: false,
              color: Colors.grey[400]!,
              onScratchEnd: _onScratchEnd,
              onThreshold: () {
                scratchedIndices.add(index);
              },
              onScratchStart: () {
                if (!gameStarted) {
                  setState(() {
                    gameStarted = true;
                  });
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 750),
                    opacity:
                        _fadeBaitRewards && rewardIds[index] != winningRewardId
                            ? 0.1
                            : 1,
                    child: Image.asset(
                      RewardService.rewardPathById(rewardIds[index]),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (!gameStarted) {
      return Shimmer.fromColors(
        period: const Duration(milliseconds: 6500),
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[200]!,
        child: pad,
      );
    }

    return pad;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(5, 10),
            ),
          ],
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
                    child: _scratchPad(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
