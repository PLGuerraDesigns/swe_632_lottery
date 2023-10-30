import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  /// The list of rewards that the player has unlocked.
  final List<int> _unlockedRewards = <int>[];

  /// Returns the list of unlocked rewards.
  List<int> get unlockedRewardIds => _unlockedRewards;

  /// Adds a reward to the list of unlocked rewards.
  void addReward(int rewardId) {
    if (_unlockedRewards.contains(rewardId)) {
      return;
    }
    _unlockedRewards.add(rewardId);
    notifyListeners();
  }
}
