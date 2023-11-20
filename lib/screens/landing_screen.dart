import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../common/strings.dart';
import '../widgets/coin_bank.dart';
import '../widgets/frosted_container.dart';
import '../widgets/game_option_card.dart';
import '../widgets/gmu_logo_background.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
import 'scratch_card_game.dart';
import 'unlocked_rewards.dart';
import 'wheel_of_fortune_game.dart';

/// The landing screen of the app.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  /// A vertical divider widget with the text "OR" in the middle.
  Widget _verticalDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: VerticalDivider(indent: 10, endIndent: 10)),
          Text(Strings.or),
          Expanded(child: VerticalDivider(indent: 10, endIndent: 10)),
        ],
      ),
    );
  }

  /// A horizontal divider widget with the text "OR" in the middle.
  Widget _horizontalDivider() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Divider(indent: 30, endIndent: 10)),
        Text(Strings.or),
        Expanded(child: Divider(indent: 10, endIndent: 30)),
      ],
    );
  }

  /// The game selection menu.
  Widget _gameSelectionMenu(
      {required BuildContext context, Orientation? orientation}) {
    final List<Widget> options = <Widget>[
      Padding(
        padding: const EdgeInsets.all(5),
        child: OutlinedButton(
          onPressed: () {
            CustomPopups().help(
              context: context,
              description: Strings.helpDetails,
            );
          },
          child: Text(
            Strings.help.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) => const UnlockedRewards(),
              ),
            );
          },
          child: Text(
            Strings.viewRewards,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    ];
    final List<Widget> children = <Widget>[
      Expanded(
        child: GameOptionCard(
          title: Strings.wheelOfFortune,
          description: Strings.wheelOfFortuneDescription,
          compact: orientation == Orientation.portrait,
          childRotation: -0.075,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) => const WheelOfFortuneGame(),
              ),
            );
          },
          child: const Wheel(),
        ),
      ),
      if (orientation == Orientation.portrait)
        _horizontalDivider()
      else
        _verticalDivider(),
      Expanded(
        child: GameOptionCard(
          title: Strings.scratchCards,
          description: Strings.scratchCardsDescription,
          compact: orientation == Orientation.portrait,
          childRotation: 0.08,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) => const ScratchCardGame(),
              ),
            );
          },
          child: CardSwiper(
              isDisabled: true,
              backCardOffset: const Offset(12, -6),
              padding: EdgeInsets.zero,
              scale: 0.98,
              numberOfCardsDisplayed: 3,
              cardsCount: 3,
              cardBuilder: (BuildContext context, int index,
                  int percentThresholdX, int percentThresholdY) {
                return const ScratchCard();
              }),
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: orientation == Orientation.portrait ? 12 : 20),
      child: FrostedContainer(
        padding: orientation == Orientation.portrait
            ? const EdgeInsets.all(4)
            : const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (orientation == Orientation.portrait)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: options),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Strings.selectGame,
                  style: orientation == Orientation.portrait
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.headlineSmall,
                ),
                if (orientation == Orientation.landscape) ...<Widget>[
                  const Spacer(),
                  ...options,
                ],
              ],
            ),
            Flexible(
              child: orientation == Orientation.portrait
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return GMUBackground(
          compact: orientation == Orientation.portrait,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: orientation == Orientation.portrait
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 120),
                    child: Text(
                      Strings.welcomeMessage,
                      style: orientation == Orientation.portrait
                          ? Theme.of(context).textTheme.titleLarge
                          : Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(
                      height: orientation == Orientation.portrait ? 12 : 20),
                  Expanded(
                    child: _gameSelectionMenu(
                      context: context,
                      orientation: orientation,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: <Widget>[
                    CoinBank(),
                    SizedBox(width: 8),
                    ThemeModeButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
