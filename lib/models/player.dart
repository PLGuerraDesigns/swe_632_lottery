import 'dart:async';

import 'package:flutter/material.dart';

import '../common/enums.dart';
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

  /// The stream controller for the reward animation.
  StreamController<int> _rewardIdController = StreamController<int>();

  /// Returns the stream controller for the reward animation.
  StreamController<int> get rewardIdController => _rewardIdController;

  /// The filter type for the rewards.
  RewardFilterType _rewardFilterType = RewardFilterType.all;

  /// Returns the filter type for the rewards.
  RewardFilterType get rewardFilterType => _rewardFilterType;

  /// Sets the filter type for the rewards.
  set rewardFilterType(RewardFilterType value) {
    if (value == RewardFilterType.locked) {
      _rewardSortType = RewardSortType.lowestCost;
    } else if (_rewardFilterType == RewardFilterType.locked) {
      _rewardSortType = RewardSortType.newest;
    }
    _rewardFilterType = value;
    notifyListeners();
  }

  /// The sort type for the rewards.
  RewardSortType _rewardSortType = RewardSortType.newest;

  /// Returns the sort type for the rewards.
  RewardSortType get rewardSortType => _rewardSortType;

  /// Sets the sort type for the rewards.
  set rewardSortType(RewardSortType value) {
    _rewardSortType = value;
    notifyListeners();
  }

  /// Add coins to the player's total.
  Future<void> addCoins(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 1250));
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

  /// Resets the reward controller.
  void resetRewardController() {
    _rewardIdController = StreamController<int>();
  }

  /// Adds a reward to the list of unlocked rewards.
  void addReward(int rewardId) {
    if (_unlockedRewards.contains(rewardId)) {
      return;
    }

    rewardIdController.add(rewardId);
    if (rewardId < 0) {
      addCoins(rewardId);
      return;
    }

    _unlockedRewards.insert(0, rewardId);
    notifyListeners();
  }
}
