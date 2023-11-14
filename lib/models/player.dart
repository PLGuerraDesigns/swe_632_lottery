import 'package:flutter/material.dart';

import '../services/reward_service.dart';

class Player extends ChangeNotifier {
  /// The list of rewards that the player has unlocked.
  final List<int> _unlockedRewards = <int>[];

  /// Returns the list of unlocked rewards.
  List<int> get unlockedRewardIds => _unlockedRewards;

  /// The number of coins that the player has collected.
  int _coins = 0;

  /// Returns the number of coins that the player has collected.
  int get coins => _coins;

  /// Add coins to the player's total.
  void addCoins(int value) {
    _coins += value.abs();
    notifyListeners();
  }

  /// Use coins to buy a reward.
  void buyReward(int rewardId) {
    final int cost = RewardService.rewardCost(rewardId);
    if (cost > _coins) {
      return;
    }
    _coins -= cost;
    addReward(rewardId);
    notifyListeners();
  }

  /// Adds a reward to the list of unlocked rewards.
  void addReward(int rewardId) {
    if (rewardId < 0) {
      addCoins(rewardId);
      return;
    }

    if (_unlockedRewards.contains(rewardId)) {
      return;
    }
    _unlockedRewards.add(rewardId);
    notifyListeners();
  }
}
