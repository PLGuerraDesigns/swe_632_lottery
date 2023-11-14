import 'package:flutter/material.dart';

import '../common/strings.dart';

import '../services/reward_service.dart';

class CustomPopups {
  void playerWonPopup({
    required BuildContext context,
    required Widget reward,
  }) {
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
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void confirmUnlockReward({
    required BuildContext context,
    required int rewardId,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              const Text('Unlock reward for'),
              const SizedBox(width: 8),
              Image.asset(
                Strings.coinAssetPath,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 4),
              Text('${RewardService.rewardCost(rewardId)} ?'),
            ],
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                RewardService.rewardPathById(rewardId),
                height: 200,
                width: 200,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm.call();
              },
              child: const Text(
                'Unlock',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  void youLostPopup({
    required BuildContext context,
    required Function()? onGoBack,
  }) {
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
                onGoBack?.call();
              },
              child: const Text('OK'),
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

  void help({required BuildContext context, required String description}) {
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
