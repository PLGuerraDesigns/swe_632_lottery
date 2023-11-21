import 'dart:ui';

import 'package:flutter/material.dart';

import 'frosted_container.dart';

/// A card that displays a game option.
class GameOptionCard extends StatefulWidget {
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

  @override
  State<GameOptionCard> createState() => _GameOptionCardState();
}

class _GameOptionCardState extends State<GameOptionCard> {
  bool _hovering = false;

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
            padding: EdgeInsets.all(widget.compact ? 8.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: widget.compact ? 8.0 : 16),
                Text(
                  widget.title,
                  style: widget.compact
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  style: widget.compact
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Padding(
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
              onTap: widget.onTap,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(widget.compact ? 20.0 : 40.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.rotationZ(
                        _hovering ? 0 : widget.childRotation,
                      )..scale(_hovering ? 1.1 : 1.0),
                      transformAlignment: Alignment.center,
                      child: widget.child,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onTap,
                  ),
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
