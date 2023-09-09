import 'dart:ui';

import 'package:flutter/material.dart';
import '../common/strings.dart';
import '../widgets/game_option_card.dart';
import '../widgets/gmu_logo_background.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
//import 'wheel_of_fortune_game.dart';
import 'scratch_card_game.dart';

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    Strings.selectGame,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: GameOptionCard(
                            title: Strings.wheelOfFortune,
                            description: Strings.wheelOfFortuneDescription,
                            childRotation: -0.1,
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             WheelOfFortuneGame()));
                            },
                            child: Wheel(),
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
                                MaterialPageRoute(
                                  builder: (context) => ScratchCardGame(),
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
          ),
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
                Flexible(flex: 3, child: _gameSelectionMenu(context)),
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
