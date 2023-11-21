// ignore: file_names
import 'dart:math';

import '../common/enums.dart';

/// The [RewardService] class is responsible for managing the rewards that the
/// user can win in the game.
class RewardService {
  RewardService._();

  /// The base path for the reward images.
  static const String _rewardBasePath = 'assets/images/items/';

  /// The maximum number of rewards available.
  static const int maxRewards = 20;

  /// The total cost of all rewards.
  static const int totalRewardCost = 10400;

  static int costOfUnlockedRewards(List<int> unlockedRewardIds) {
    int costOfUnlockedRewards = 0;
    for (final int i in RewardService.rewardIds(
        unlockedRewardIds: unlockedRewardIds,
        filterType: RewardFilterType.unlocked)) {
      costOfUnlockedRewards += RewardService.rewardCost(i);
    }
    return costOfUnlockedRewards;
  }

  static int costOfRemainingRewards(List<int> unlockedRewardIds) =>
      totalRewardCost - costOfUnlockedRewards(unlockedRewardIds);

  /// Returns a list of reward ids sorted and filtered by the given parameters.
  static List<int> rewardIds({
    RewardFilterType filterType = RewardFilterType.all,
    RewardSortType sortType = RewardSortType.newest,
    List<int> unlockedRewardIds = const <int>[],
  }) {
    final List<int> rewardIds =
        _sorted(orderType: sortType, unlockedRewardIds: unlockedRewardIds);
    return _filtered(
      filterType: filterType,
      rewardIds: rewardIds,
      unlockedRewardIds: unlockedRewardIds,
    );
  }

  /// Returns a list of reward ids sorted by the given [orderType].
  static List<int> _sorted(
      {required RewardSortType orderType,
      required List<int> unlockedRewardIds}) {
    final List<int> rewardIds = <int>[];

    switch (orderType) {
      case RewardSortType.lowestCost:
        rewardIds.addAll(List<int>.generate(maxRewards, (int index) => index)
            .where((int element) => !unlockedRewardIds.contains(element)));
      case RewardSortType.highestCost:
        rewardIds.addAll(List<int>.generate(maxRewards, (int index) => index)
            .where((int element) => !unlockedRewardIds.contains(element))
            .toList()
            .reversed);
      case RewardSortType.newest:
        rewardIds.addAll(unlockedRewardIds);
        rewardIds.addAll(List<int>.generate(maxRewards, (int index) => index)
            .where((int element) => !rewardIds.contains(element)));
      case RewardSortType.oldest:
        rewardIds.addAll(unlockedRewardIds.reversed);
        rewardIds.addAll(List<int>.generate(maxRewards, (int index) => index)
            .where((int element) => !rewardIds.contains(element)));
    }
    return rewardIds;
  }

  /// Returns a list of reward ids filtered by the given [filterType].
  static List<int> _filtered({
    required RewardFilterType filterType,
    required List<int> rewardIds,
    required List<int> unlockedRewardIds,
  }) {
    switch (filterType) {
      case RewardFilterType.all:
        return rewardIds;
      case RewardFilterType.unlocked:
        return rewardIds
            .where((int element) => unlockedRewardIds.contains(element))
            .toList();
      case RewardFilterType.locked:
        return rewardIds
            .where((int element) => !unlockedRewardIds.contains(element))
            .toList();
    }
  }

  /// Returns the path for the reward image with the given [id].
  static String rewardPathById(int id) {
    if (id < 0) {
      return coinPathByValue(id);
    }
    return '$_rewardBasePath$id.png';
  }

  /// Returns the path for the coin image with the given [value].
  static String coinPathByValue(int value) {
    return 'assets/images/coins/${value.abs()}.png';
  }

  /// Returns the cost of the reward with the given [rewardId].
  static int rewardCost(int rewardId) {
    if (rewardId < 4) {
      return 100;
    } else if (rewardId < 8) {
      return 250;
    } else if (rewardId < 12) {
      return 500;
    } else if (rewardId < 16) {
      return 750;
    } else {
      return 1000;
    }
  }

  /// Returns a random coin value.
  static int _randomCoinValue() {
    final List<int> coinValues = <int>[-5, -10, -25, -50];
    return coinValues[Random().nextInt(coinValues.length)];
  }

  /// Returns a list of random reward ids with size [numberOfRewards].
  static List<int> randomRewardIds(int numberOfRewards,
      {bool coinBias = false}) {
    final List<int> rewardIds = <int>[];
    final List<int> coinValuesAttempted = <int>[];
    for (int i = 0; i < numberOfRewards; i++) {
      final bool coinsAsReward = Random().nextInt(100) < (coinBias ? 75 : 50);
      if (coinsAsReward) {
        int coinValue = _randomCoinValue();
        while (rewardIds.where((int id) => id == coinValue).length > 1) {
          coinValue = _randomCoinValue();
          if (!coinValuesAttempted.contains(coinValue)) {
            coinValuesAttempted.add(coinValue);
          }
          if (coinValuesAttempted.length == 4) {
            break;
          }
        }
        rewardIds.add(coinValue);
        continue;
      }

      int reward = Random().nextInt(maxRewards);
      while (rewardIds.contains(reward)) {
        reward = Random().nextInt(maxRewards);
      }
      rewardIds.add(reward);
    }
    return rewardIds;
  }
}
