import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../widgets/gmu_logo_background.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/scratch_card.dart';
import '../widgets/theme_mode_button.dart';
import 'game_screen.dart';

class ScratchCardGame extends StatelessWidget {
  const ScratchCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      appBar: AppBar(
        title: const Text(Strings.wheelOfFortune),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              CustomPopups().howToPlayPopup(
                context: context,
                description: 'description',
              );
            },
            icon: const Icon(Icons.help),
          ),
          const ThemeModeButton(),
        ],
      ),
      description: Strings.scratchCardsDescription,
      child: const Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ScratchCard(),
          ),
        ],
      ),
    );
  }
}
