import 'package:flutter/material.dart';

import '../common/strings.dart';
import '../widgets/popup_dialogs.dart';
import '../widgets/theme_mode_button.dart';
import '../widgets/wheel.dart';
import 'game_screen.dart';

class WheelOfFortuneGame extends StatelessWidget {
  const WheelOfFortuneGame({super.key});

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
      description: Strings.wheelOfFortuneDescription,
      child: const Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Wheel(),
            ),
          ),
        ],
      ),
    );
  }
}
