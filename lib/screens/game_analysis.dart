import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../services/reward_service.dart';
import '../widgets/bar_chart_viewer.dart';
import '../widgets/coin_bank.dart';
import '../widgets/frosted_container.dart';
import '../widgets/gmu_logo_background.dart';
import '../widgets/theme_mode_button.dart';

class GameAnalysisScreen extends StatefulWidget {
  const GameAnalysisScreen({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  GameAnalysisState createState() => GameAnalysisState();
}

class GameAnalysisState extends State<GameAnalysisScreen> {
  /// The controller for the scroll view.
  final ScrollController _scrollController = ScrollController();

  bool _chartView = false;

  /// Data table for coins analysis.
  Widget _coinsAnalysisTable({
    required int totalCoins,
    required int coinsSpent,
  }) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(20),
      ),
      children: <TableRow>[
        _tableRow(
            label: Strings.totalCoinsEarned, value: totalCoins.toString()),
        _tableRow(
            label: Strings.currentCoins,
            value: (totalCoins - coinsSpent).toString()),
        _tableRow(label: Strings.coinsSpent, value: coinsSpent.toString()),
      ],
    );
  }

  /// Bar chart for coins analysis.
  Widget _coinsAnalysisGraph({
    required int totalCoins,
    required int coinsSpent,
  }) {
    return SizedBox(
      height: 200,
      child: BarChartViewer(
        maxValue: totalCoins,
        data: <int>[coinsSpent, totalCoins - coinsSpent],
        labels: const <String>[Strings.coinsSpent, Strings.currentCoins],
      ),
    );
  }

  /// Data table for rewards analysis.
  Widget _rewardsAnalysisTable({
    required List<int> rewardsUnlocked,
  }) {
    return Column(
      children: <Widget>[
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(20),
          ),
          children: <TableRow>[
            _tableRow(
              label: Strings.totalRewards,
              value: RewardService.maxRewards.toString(),
            ),
            _tableRow(
              label: Strings.lockedRewards,
              value: (RewardService.maxRewards - rewardsUnlocked.length)
                  .toString(),
            ),
            _tableRow(
              label: Strings.unlockedRewards,
              value: rewardsUnlocked.length.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(20),
          ),
          children: <TableRow>[
            _tableRow(
              label: Strings.totalCostOfRewards,
              value: RewardService.totalRewardCost.toString(),
            ),
            _tableRow(
              label: Strings.costOfRemainingLockedRewards,
              value: RewardService.costOfRemainingRewards(rewardsUnlocked)
                  .toString(),
            ),
            _tableRow(
              label: Strings.costOfUnlockedRewards,
              value: RewardService.costOfUnlockedRewards(rewardsUnlocked)
                  .toString(),
            ),
          ],
        ),
      ],
    );
  }

  /// Bar chart for rewards analysis.
  Widget _rewardsAnalysisGraph({
    required List<int> rewardsUnlocked,
    required int coinsSpent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 200,
          child: BarChartViewer(
            maxValue: RewardService.maxRewards,
            data: <int>[
              RewardService.maxRewards - rewardsUnlocked.length,
              rewardsUnlocked.length
            ],
            labels: const <String>[
              Strings.lockedRewards,
              Strings.unlockedRewards
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: BarChartViewer(
            maxValue: RewardService.totalRewardCost,
            data: <int>[
              RewardService.costOfUnlockedRewards(rewardsUnlocked),
              RewardService.costOfRemainingRewards(rewardsUnlocked)
            ],
            labels: const <String>[
              Strings.costOfUnlockedRewards,
              Strings.costOfRemainingLockedRewards
            ],
          ),
        ),
      ],
    );
  }

  /// Data table for game analysis.
  Widget _gameAnalysisTable({
    required int totalGamesPlayed,
    required int totalGamesWon,
    required int totalGamesLost,
    required int totalCoinsEarnedPlayingScratchCards,
    required List<int> rewardsUnlockedPlayingScratchCards,
    required int totalCoinsEarnedPlayingWheelOfFortune,
    required List<int> rewardsUnlockedPlayingWheelOfFortune,
  }) {
    return Column(
      children: <Widget>[
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(20),
          ),
          children: <TableRow>[
            _tableRow(
              label: Strings.totalGamesPlayed,
              value: totalGamesPlayed.toString(),
            ),
            _tableRow(
              label: Strings.gamesWon,
              value: totalGamesWon.toString(),
            ),
            _tableRow(
              label: Strings.gamesLost,
              value: totalGamesLost.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(20),
          ),
          children: <TableRow>[
            _tableRow(
              label: Strings.coinsWonPlayingScratchCards,
              value: totalCoinsEarnedPlayingScratchCards.toString(),
            ),
            _tableRow(
              label: Strings.coinsWonPlayingWheelOfFortune,
              value: totalCoinsEarnedPlayingWheelOfFortune.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Table(
          border: TableBorder.all(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(20),
          ),
          children: <TableRow>[
            _tableRow(
              label: Strings.rewardsWonPlayingScratchCards,
              value: rewardsUnlockedPlayingScratchCards.length.toString(),
            ),
            _tableRow(
              label: Strings.rewardsWonPlayingWheelOfFortune,
              value: rewardsUnlockedPlayingWheelOfFortune.length.toString(),
            ),
          ],
        ),
      ],
    );
  }

  /// Bar chart for game analysis.
  Widget _gameAnalysisGraph({
    required int totalGamesPlayed,
    required int totalGamesWon,
    required int totalGamesLost,
    required int totalCoinsEarnedPlayingScratchCards,
    required List<int> rewardsUnlockedPlayingScratchCards,
    required int totalCoinsEarnedPlayingWheelOfFortune,
    required List<int> rewardsUnlockedPlayingWheelOfFortune,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 200,
          child: BarChartViewer(
            maxValue: totalGamesPlayed,
            data: <int>[totalGamesWon, totalGamesLost],
            labels: const <String>[Strings.gamesWon, Strings.gamesLost],
          ),
        ),
        SizedBox(
          height: 200,
          child: BarChartViewer(
            maxValue: totalCoinsEarnedPlayingScratchCards +
                totalCoinsEarnedPlayingWheelOfFortune,
            data: <int>[
              totalCoinsEarnedPlayingScratchCards,
              totalCoinsEarnedPlayingWheelOfFortune
            ],
            labels: const <String>[
              Strings.coinsWonPlayingScratchCards,
              Strings.coinsWonPlayingWheelOfFortune
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: BarChartViewer(
            maxValue: RewardService.maxRewards,
            data: <int>[
              rewardsUnlockedPlayingScratchCards.length,
              rewardsUnlockedPlayingWheelOfFortune.length
            ],
            labels: const <String>[
              Strings.rewardsWonPlayingScratchCards,
              Strings.rewardsWonPlayingWheelOfFortune
            ],
          ),
        ),
      ],
    );
  }

  /// Returns a table row with the given [label] and [value].
  TableRow _tableRow({
    required String label,
    required String value,
  }) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  /// Returns a section header with the given [text].
  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Consumer<Player>(
          builder: (BuildContext context, Player player, Widget? child) {
            return GMUBackground(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(Strings.gameAnalysis),
                  centerTitle: false,
                  actions: const <Widget>[
                    CoinBank(),
                    SizedBox(width: 16),
                    ThemeModeButton(),
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(widget.compact ? 12 : 20),
                  child: FrostedContainer(
                    padding: EdgeInsets.all(widget.compact ? 0 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _chartView = !_chartView;
                            });
                          },
                          child: Text(
                            _chartView
                                ? Strings.tableView.toUpperCase()
                                : Strings.chartView.toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _sectionHeader(
                                    Strings.coinsAnalysis,
                                  ),
                                  if (!_chartView)
                                    _coinsAnalysisTable(
                                      totalCoins: player.totalCoins,
                                      coinsSpent: player.coinsSpent,
                                    ),
                                  if (_chartView)
                                    _coinsAnalysisGraph(
                                        totalCoins: player.totalCoins,
                                        coinsSpent: player.coinsSpent),
                                  const SizedBox(height: 16),
                                  _sectionHeader(
                                    Strings.rewardsAnalysis,
                                  ),
                                  if (!_chartView)
                                    _rewardsAnalysisTable(
                                      rewardsUnlocked: player.unlockedRewardIds,
                                    ),
                                  if (_chartView)
                                    _rewardsAnalysisGraph(
                                      rewardsUnlocked: player.unlockedRewardIds,
                                      coinsSpent: player.coinsSpent,
                                    ),
                                  const SizedBox(height: 16),
                                  _sectionHeader(
                                    Strings.gamesAnalysis,
                                  ),
                                  if (!_chartView)
                                    _gameAnalysisTable(
                                      totalGamesPlayed:
                                          player.numberOfGamesPlayed,
                                      totalGamesWon: player.numberOfGamesWon,
                                      totalGamesLost: player.numberOfGamesLost,
                                      totalCoinsEarnedPlayingScratchCards:
                                          player.coinsWonPlayingScratchCards,
                                      rewardsUnlockedPlayingScratchCards: player
                                          .unlockedRewardsPlayingScratchCards,
                                      totalCoinsEarnedPlayingWheelOfFortune:
                                          player.coinsWonPlayingWheelOfFortune,
                                      rewardsUnlockedPlayingWheelOfFortune: player
                                          .unlockedRewardsPlayingWheelOfFortune,
                                    ),
                                  if (_chartView)
                                    _gameAnalysisGraph(
                                      totalGamesPlayed:
                                          player.numberOfGamesPlayed,
                                      totalGamesWon: player.numberOfGamesWon,
                                      totalGamesLost: player.numberOfGamesLost,
                                      totalCoinsEarnedPlayingScratchCards:
                                          player.coinsWonPlayingScratchCards,
                                      rewardsUnlockedPlayingScratchCards: player
                                          .unlockedRewardsPlayingScratchCards,
                                      totalCoinsEarnedPlayingWheelOfFortune:
                                          player.coinsWonPlayingWheelOfFortune,
                                      rewardsUnlockedPlayingWheelOfFortune: player
                                          .unlockedRewardsPlayingWheelOfFortune,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
