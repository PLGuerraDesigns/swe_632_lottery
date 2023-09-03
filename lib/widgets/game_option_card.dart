import 'dart:ui';

import 'package:flutter/material.dart';

/// A card that displays a game option.
class GameOptionCard extends StatelessWidget {
  const GameOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.child,
    this.childRotation = 0,
  });

  /// The name of the game option.
  final String title;

  /// The description of the game option.
  final String description;

  /// The child widget to display.
  final Widget child;

  /// The function to call when the card is tapped.
  final Function()? onTap;

  /// The rotation of the child widget.
  final double childRotation;

  Widget _banner(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: InkWell(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Transform.rotate(angle: childRotation, child: child),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _banner(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
