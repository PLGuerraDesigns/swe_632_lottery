import 'package:flutter/material.dart';

import '../common/strings.dart';

/// Adds a GMU logo and clock tower behind the child widget.
class GMUBackground extends StatelessWidget {
  const GMUBackground({
    super.key,
    required this.child,
  });

  /// The child widget to display on top of the background.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: Image.asset(
            Strings.gmu_logo_cropped,
            height: MediaQuery.of(context).size.height * 0.85,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 30,
          child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                Strings.gmu_clock_tower,
                height: MediaQuery.of(context).size.height * 0.85,
                color: Theme.of(context).colorScheme.onSurface,
              )),
        ),
        child,
      ],
    );
  }
}
