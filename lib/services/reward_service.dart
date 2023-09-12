// ignore: file_names
/// The [RewardService] class is responsible for managing the rewards that the
/// user can win in the game.
class RewardService {
  final String _rewardBasePath = 'assets/items/';
  final int maxRewards = 20;

  String rewardById(int id) {
    return '$_rewardBasePath$id.png';
  }
}
