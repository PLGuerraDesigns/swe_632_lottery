import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/color_schemes.dart';
import 'common/strings.dart';
import 'common/theme.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const LotteryGame());
}

/// The entry point of the application.
class LotteryGame extends StatefulWidget {
  const LotteryGame({super.key});

  @override
  State<LotteryGame> createState() => _LotteryGameState();
}

class _LotteryGameState extends State<LotteryGame> {
  /// The [ThemeNotifier] instance.
  late ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  void initState() {
    super.initState();

    themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>.value(
      value: themeNotifier,
      child: MaterialApp(
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
        themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: lightTextTheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          textTheme: darkTextTheme,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
