import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:roll_my_dice/app/home/pages/roll_dice_page.dart';

class Dice extends StatelessWidget {
  void updateDices(DiceModel dice) async {
    dice.generateDiceOne();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _diceOneImages = [
      "assets/images/dice1.png",
      "assets/images/dice2.png",
      "assets/images/dice3.png",
      "assets/images/dice4.png",
      "assets/images/dice5.png",
      "assets/images/dice6.png",
    ];
    final dice = Provider.of<DiceModel>(context);
    final c = dice.diceOneCount;
    var img = Image.asset(
      _diceOneImages[c - 1],
      gaplessPlayback: true,
    );
    return GestureDetector(
      onTap: () => updateDices(dice),
      child: img,
    );
  }
}

