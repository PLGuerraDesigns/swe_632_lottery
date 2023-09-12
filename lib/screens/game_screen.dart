import 'package:flutter/material.dart';

import '../widgets/frosted_container.dart';
import '../widgets/gmu_logo_background.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.child,
    this.description,
    this.appBar,
  });
  final Widget child;
  final String? description;
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
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    description!,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
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
