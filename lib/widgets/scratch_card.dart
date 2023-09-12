import 'dart:math';

import 'package:flutter/material.dart';

import '../common/strings.dart';
import 'package:scratcher/scratcher.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({super.key});

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  bool userWon = false;

  List<Widget> rewards = <Widget>[];

  /// Prepares the list of rewards to be displayed.
  void _prepareRewards() {
    List<int> itemIds = <int>[];

    bool empty;
    int count = 0;

    for (int i = 0; i < 9; i++) {
      empty = Random().nextBool();
      count = 0;

      if (empty) {
        rewards.add(_emptyReward());
      } else {
        final int randomItem = Random().nextInt(7);
        rewards.add(
          Image.asset('assets/items/$randomItem.jpeg'),
        );

        /// Loop through all items and see if the random item is already in the list.
        for (int j = 0; j < itemIds.length; j++) {
          /// If the random item is already in the list, increment the count.
          if (randomItem == itemIds[j]) {
            count++;
          }

          /// If the random item is already in the list twice, print a message.
          if (count >= 2) {
            userWon = true;
            print('You won!');
          }

          itemIds.add(randomItem);
        }
      }
    }
  }

  Widget _emptyReward() {
    return Container(
      child: const Padding(
        padding: EdgeInsets.all(50),
        child: Icon(
          Icons.thumb_down,
          size: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _prepareRewards();

    return Container(
      height: 500,
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: 9,
                      itemBuilder: (BuildContext context, int index) {
                        return Scratcher(
                          brushSize: 30,
                          threshold: 50,
                          color: Colors.grey,
                          child: rewards[index],
                          onScratchEnd: () {
                            if (userWon) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'User Won!',
                                    ),
                                    content: const Text(
                                      'You won a prize!',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Start Over',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
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
