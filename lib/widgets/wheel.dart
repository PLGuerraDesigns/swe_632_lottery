import 'package:flutter/material.dart';

import '../common/strings.dart';

/// A wheel that the user can spin to win a prize.
class Wheel extends StatelessWidget {
  const Wheel({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 250,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: CircleAvatar(
        radius: 245,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              Strings.spinToWin,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
