import 'package:flutter/material.dart';

import '../common/strings.dart';

/// A scratch card that the user can scratch to reveal a prize.
class ScratchCard extends StatefulWidget {
  const ScratchCard({super.key});

  @override
  ScratchCardState createState() => ScratchCardState();
}

class ScratchCardState extends State<ScratchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                Strings.scratchAndWin,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
