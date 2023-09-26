import 'package:flutter/material.dart';
import '../common/strings.dart';
import '../widgets/frosted_container.dart';
import '../widgets/game_option_card.dart';
import '../widgets/gmu_logo_background.dart';
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

  /// The game selection menu.
  Widget _gameSelectionMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: FrostedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  Strings.selectGame,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) =>
                            const UnlockedRewards(),
                      ),
                    );
                  },
                  child: Text(
                    'VIEW ALL REWARDS',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: GameOptionCard(
                      title: Strings.wheelOfFortune,
                      description: Strings.wheelOfFortuneDescription,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                const WheelOfFortuneGame(),
                          ),
                        );
                      },
                      child: const Wheel(),
                    ),
                  ),
                  _verticalDivider(),
                  Expanded(
                    child: GameOptionCard(
                      title: Strings.scratchCards,
                      description: Strings.scratchCardsDescription,
                      childRotation: 0.08,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                const ScratchCardGame(),
                          ),
                        );
                      },
                      child: const ScratchCard(),
                    ),
                  ),
                ],
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
      body: GMUBackground(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 40),
                Text(
                  Strings.welcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: _gameSelectionMenu(context),
                ),
                const SizedBox(height: 40),
              ],
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: ThemeModeButton(),
            ),
          ],
        ),
      ),
    );
  }
}
