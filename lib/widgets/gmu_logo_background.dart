import 'package:flutter/material.dart';

import '../common/strings.dart';

/// Adds a GMU logo and clock tower behind the child widget.
class GMUBackground extends StatelessWidget {
  const GMUBackground({
    super.key,
    required this.child,
    this.compact = false,
  });

  /// The child widget to display on top of the background.
  final Widget child;

  /// Whether the background should be displayed in compact mode.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: Image.asset(
            Strings.gmuLogoCropped,
            height: MediaQuery.of(context).size.height * 0.85,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        if (!compact)
          Positioned(
            bottom: 0,
            right: 30,
            child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  Strings.gmuClockTower,
                  height: MediaQuery.of(context).size.height * 0.85,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
          ),
        child,
      ],
    );
  }
}
