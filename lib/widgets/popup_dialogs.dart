import 'package:flutter/material.dart';

import '../screens/unlocked_rewards.dart';

class CustomPopups {
  void playerWonPopup(
      {required BuildContext context,
      required Widget reward,
      Function()? onPlayAgain}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You won a prize!'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: reward,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => const UnlockedRewards(),
                  ),
                );
              },
              child: const Text('View Rewards'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPlayAgain?.call();
              },
              child: const Text('Play Again'),
            )
          ],
        );
      },
    );
  }

  void youLostPopup({required BuildContext context, Function()? onPlayAgain}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You lost!'),
          content: const Text('Better luck next time!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => const UnlockedRewards(),
                  ),
                );
              },
              child: const Text('View Rewards'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPlayAgain?.call();
              },
              child: const Text('Play Again'),
            )
          ],
        );
      },
    );
  }

  void howToPlayPopup(
      {required BuildContext context, required String description}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Play.'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Got it!'),
            )
          ],
        );
      },
    );
  }
}
