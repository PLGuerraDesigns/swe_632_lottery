import 'dart:async';

import 'package:flutter/material.dart';

import '../common/enums.dart';
import '../services/reward_service.dart';

class Player extends ChangeNotifier {
  /// The number of coins that the player has collected.
  int _coins = 0;

  /// The number of coins that the player has spent.
  int _coinsDeducted = 0;

  /// The number of coins won playing the scratch card game.
  int _coinsWonPlayingScratchCards = 0;

  /// The number of coins won playing the wheel of fortune game.
  int _coinsWonPlayingWheelOfFortune = 0;

  /// The number of scratch card games played.
  int _numberOfScratchCardGamesPlayed = 0;

  /// The number of wheel of fortune games played.
  int _numberOfWheelOfFortuneGamesPlayed = 0;

  /// The number of games won.
  int _numberOfGamesWon = 0;

  /// The list of rewards unlocked by the player while playing the scratch card
  /// game.
  final List<int> _unlockedRewardsPlayingScratchCards = <int>[];

  /// The list of rewards unlocked by the player while playing the wheel of
  /// fortune game.
  final List<int> _unlockedRewardsPlayingWheelOfFortune = <int>[];

  /// The list of rewards unlocked in order of when they were unlocked.
  /// Recently unlocked rewards are at the front of the list.
  final List<int> _unlockedRewards = <int>[];

  /// The number of coins that the player has collected playing the scratch card
  /// game.
  int get coinsWonPlayingScratchCards => _coinsWonPlayingScratchCards;

  /// The number of coins that the player has collected playing the wheel of
  /// fortune game.
  int get coinsWonPlayingWheelOfFortune => _coinsWonPlayingWheelOfFortune;

  /// The number of games lost.
  int get numberOfGamesLost => numberOfGamesPlayed - _numberOfGamesWon;

  /// The number of games won.
  int get numberOfGamesWon => _numberOfGamesWon;

  /// The number of scratch card games played.
  int get numberOfScratchCardGamesPlayed => _numberOfScratchCardGamesPlayed;

  /// The number of wheel of fortune games played.
  int get numberOfWheelOfFortuneGamesPlayed =>
      _numberOfWheelOfFortuneGamesPlayed;

  /// Returns the number of games played.
  int get numberOfGamesPlayed =>
      _numberOfScratchCardGamesPlayed + _numberOfWheelOfFortuneGamesPlayed;

  /// Returns the list of unlocked rewards.
  List<int> get unlockedRewardIds => _unlockedRewards;

  /// Returns the list of unlocked rewards while playing the scratch card game.
  List<int> get unlockedRewardsPlayingScratchCards =>
      _unlockedRewardsPlayingScratchCards;

  /// Returns the list of unlocked rewards while playing the wheel of fortune
  /// game.
  List<int> get unlockedRewardsPlayingWheelOfFortune =>
      _unlockedRewardsPlayingWheelOfFortune;

  /// Returns the number of coins that the player has collected.
  int get coins => _coins - _coinsDeducted;

  /// Returns the total number of coins that the player has collected.
  int get totalCoins => _coins;

  /// Returns the number of coins that the player has spent.
  int get coinsSpent => _coinsDeducted;

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

  /// Increments the number of scratch card games played.
  void incrementNumberOfScratchCardGamesPlayed() {
    _numberOfScratchCardGamesPlayed++;
  }

  /// Increments the number of wheel of fortune games played.
  void incrementNumberOfWheelOfFortuneGamesPlayed() {
    _numberOfWheelOfFortuneGamesPlayed++;
  }

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
    _coinsDeducted += cost;
    _addReward(rewardId);
    notifyListeners();
  }

  /// Resets the reward controller.
  void resetRewardController() {
    _rewardIdController = StreamController<int>();
  }

  /// Adds a reward to the list of unlocked rewards while playing the scratch
  /// card game.
  void addRewardFromScratchCard(int rewardId) {
    if (_unlockedRewards.contains(rewardId)) {
      return;
    }
    rewardIdController.add(rewardId);
    _numberOfGamesWon++;

    if (rewardId < 0) {
      _coinsWonPlayingScratchCards += rewardId.abs();
      addCoins(rewardId);
      return;
    }

    _unlockedRewardsPlayingScratchCards.add(rewardId);
    _addReward(rewardId);
  }

  /// Adds a reward to the list of unlocked rewards while playing the wheel of
  /// fortune game.
  void addRewardFromWheelOfFortune(int rewardId) {
    if (_unlockedRewards.contains(rewardId)) {
      return;
    }

    rewardIdController.add(rewardId);
    _numberOfGamesWon++;

    if (rewardId < 0) {
      _coinsWonPlayingWheelOfFortune += rewardId.abs();
      addCoins(rewardId);
      return;
    }

    _unlockedRewardsPlayingWheelOfFortune.add(rewardId);
    _addReward(rewardId);
  }

  /// Adds a reward to the list of unlocked rewards.
  void _addReward(int rewardId) {
    _unlockedRewards.insert(0, rewardId);
    notifyListeners();
  }
}
