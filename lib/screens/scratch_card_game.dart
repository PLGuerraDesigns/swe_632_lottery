import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../common/strings.dart';
import '../models/player.dart';
import '../widgets/coin_bank.dart';
import '../widgets/hover_scale_handler.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/rewards_bar.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

/// The Scratch Cards game screen.
class ScratchCardGame extends StatefulWidget {
  const ScratchCardGame({
    super.key,
  });

  @override
  State<ScratchCardGame> createState() => _ScratchCardGameState();
}

class _ScratchCardGameState extends State<ScratchCardGame> {
  /// The controller for the [CardSwiper].
  final CardSwiperController _controller = CardSwiperController();

  /// Whether the game has ended.
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Player>(context, listen: false).resetRewardController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
      builder: (BuildContext context, Player player, Widget? child) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          return GameScreen(
            compact: orientation == Orientation.portrait,
            rewardIdController: player.rewardIdController,
            appBar: AppBar(
              title: const Text(Strings.scratchCards),
              centerTitle: false,
              actions: const <Widget>[
                CoinBank(),
                SizedBox(width: 16),
                ThemeModeButton(),
              ],
            ),
            header: orientation == Orientation.landscape
                ? null
                : Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        Strings.howToPlay.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () {
                        CustomPopups().howToPlayPopup(
                          context: context,
                          description: Strings.scratchTheCardHowToPlay,
                        );
                      },
                    ),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (orientation == Orientation.portrait) const Spacer(),
                    Text(
                      Strings.getThreeOfTheSameItemToWin,
                      style: orientation == Orientation.portrait
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    if (orientation == Orientation.landscape)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(
                          Strings.howToPlay.toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        onPressed: () {
                          CustomPopups().howToPlayPopup(
                            context: context,
                            description: Strings.scratchTheCardHowToPlay,
                          );
                        },
                      )
                  ],
                ),
                Expanded(
                  child: CardSwiper(
                    isDisabled: !gameEnded,
                    controller: _controller,
                    maxAngle: 50,
                    backCardOffset:
                        gameEnded ? const Offset(10, 10) : const Offset(3, 3),
                    scale: 1,
                    numberOfCardsDisplayed: 3,
                    cardsCount: 3,
                    onSwipe: (int previousIndex, int? currentIndex,
                        CardSwiperDirection direction) {
                      setState(() {
                        gameEnded = false;
                      });
                      return true;
                    },
                    cardBuilder: (BuildContext context, int index,
                        int percentThresholdX, int percentThresholdY) {
                      return ScratchCard(
                        key: ValueKey<int>(index),
                        gameEnded: gameEnded,
                        onGameEnd: (int? rewardId) {
                          setState(() {
                            gameEnded = true;
                          });
                          if (rewardId == null) {
                            return;
                          }
                          player.addReward(rewardId);
                        },
                      );
                    },
                  ),
                ),
                AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: gameEnded ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: HoverScaleHandler(
                        onTap: _controller.swipe,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          child: Shimmer.fromColors(
                            period: const Duration(milliseconds: 5000),
                            baseColor: Theme.of(context).colorScheme.onPrimary,
                            highlightColor: Color.alphaBlend(
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.8),
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Text(
                                Strings.playAgain.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RewardsBar(
                  unlockedRewardIds: player.unlockedRewardIds,
                  returnScreenFromUnlockedRewards: const ScratchCardGame(),
                  resetAnimationController: player.resetRewardController,
                  playerCoins: player.coins,
                  onRewardTap: (int rewardId) {
                    CustomPopups().confirmUnlockReward(
                      context: context,
                      rewardId: rewardId,
                      onConfirm: () => player.buyReward(rewardId),
                    );
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
