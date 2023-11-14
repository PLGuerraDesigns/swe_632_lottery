import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/strings.dart';
import '../models/player.dart';

class CoinBank extends StatelessWidget {
  const CoinBank({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Player>(
        builder: (BuildContext context, Player player, Widget? child) {
      return Row(
        children: <Widget>[
          Image.asset(
            Strings.coinAssetPath,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          Text(
            player.coins.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      );
    });
  }
}
