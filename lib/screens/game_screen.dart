import 'package:flutter/material.dart';

import '../widgets/frosted_container.dart';
import '../widgets/gmu_logo_background.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.description,
    required this.child,
    this.appBar,
  });
  final String description;
  final Widget child;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GMUBackground(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                description,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: FrostedContainer(
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
