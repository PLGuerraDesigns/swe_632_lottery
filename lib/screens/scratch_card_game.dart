import 'package:flutter/material.dart';

import '../widgets/gmu_logo_background.dart';
import '../widgets/scratch_card.dart';

class ScratchCardGame extends StatelessWidget {
  const ScratchCardGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scratch Card Game'),
      ),
      body: GMUBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Hello World'),
            Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ScratchCard(),
            )
          ],
        ),
      ),
    );
  }
}
