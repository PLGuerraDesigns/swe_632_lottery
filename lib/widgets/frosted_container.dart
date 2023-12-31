import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedContainer extends StatelessWidget {
  const FrostedContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.compact = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 12 : 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(compact ? 12 : 24),
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
