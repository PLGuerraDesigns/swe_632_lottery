// ignore: file_names
import 'dart:math';

/// The [RewardService] class is responsible for managing the rewards that the
/// user can win in the game.
class RewardService {
  RewardService._();

  /// The base path for the reward images.
  static const String _rewardBasePath = 'assets/images/items/';

  /// The maximum number of rewards available.
  static const int maxRewards = 20;

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
  static List<int> randomRewardIds(int numberOfRewards) {
    final List<int> rewardIds = <int>[];
    final List<int> coinValuesAttempted = <int>[];
    for (int i = 0; i < numberOfRewards; i++) {
      final bool coinsAsReward = Random().nextInt(100) < 30;
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
