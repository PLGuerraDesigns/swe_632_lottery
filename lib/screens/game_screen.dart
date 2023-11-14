import 'package:flutter/material.dart';

import '../widgets/frosted_container.dart';
import '../widgets/gmu_logo_background.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
    required this.child,
    this.header,
    this.appBar,
    this.compact = false,
  });
  final Widget child;
  final Widget? header;
  final AppBar? appBar;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: GMUBackground(
        compact: compact,
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 20),
          child: FrostedContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: header,
                ),
              Expanded(
                child: child,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
