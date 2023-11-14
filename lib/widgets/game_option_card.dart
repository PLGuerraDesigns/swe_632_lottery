import 'dart:ui';

import 'package:flutter/material.dart';

import 'frosted_container.dart';

/// A card that displays a game option.
class GameOptionCard extends StatelessWidget {
  const GameOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.child,
    required this.compact,
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

  /// Whether the card should be displayed in compact mode.
  final bool compact;

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
            padding: EdgeInsets.all(compact ? 8.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: compact ? 8.0 : 16),
                Text(
                  title,
                  style: compact
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: compact
                      ? Theme.of(context).textTheme.bodyMedium
                      : Theme.of(context).textTheme.titleMedium,
                ),
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
        child: FrostedContainer(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(compact ? 20.0 : 40.0),
                  child: Transform.rotate(angle: childRotation, child: child),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTap,
                ),
                Align(
                    alignment: Alignment.bottomCenter, child: _banner(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
