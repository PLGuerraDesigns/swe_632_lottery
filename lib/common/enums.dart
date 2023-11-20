/// The different types of filters for the rewards.
enum RewardFilterType {
  /// All rewards
  all,

  /// Unlocked rewards only
  unlocked,

  /// Locked rewards only
  locked,
}

extension RewardFilterTypeExtension on RewardFilterType {
  /// Returns the string representation of the reward filter type.
  String get stringFromEnum {
    switch (this) {
      case RewardFilterType.all:
        return 'All';
      case RewardFilterType.unlocked:
        return 'Unlocked';
      case RewardFilterType.locked:
        return 'Locked';
    }
  }
}

/// The different types of sorting for the rewards.
enum RewardSortType {
  /// Sort by newest
  newest,

  /// Sort by oldest
  oldest,

  /// Sort by highest cost
  highestCost,

  /// Sort by lowest cost
  lowestCost,
}

extension RewardSortTypeExtension on RewardSortType {
  /// Returns the string representation of the reward sort type.
  String get stringFromEnum {
    switch (this) {
      case RewardSortType.newest:
        return 'Newest';
      case RewardSortType.oldest:
        return 'Oldest';
      case RewardSortType.lowestCost:
        return 'Price: Low-High';
      case RewardSortType.highestCost:
        return 'Price: High-Low';
    }
  }
}
