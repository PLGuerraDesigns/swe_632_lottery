import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/theme.dart';

/// A button that toggles the theme mode.
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ThemeNotifier>(
        builder: (BuildContext context, ThemeNotifier themeNotifier,
                Widget? child) =>
            IconButton(
          icon: Icon(
              themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          tooltip: 'Toggle Theme',
          onPressed: () {
            themeNotifier.setDarkTheme(!themeNotifier.isDarkMode);
          },
        ),
      ),
    );
  }
}
