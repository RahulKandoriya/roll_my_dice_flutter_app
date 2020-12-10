import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roll_my_dice/app/home/pages/dice.dart';

class RollDicePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DiceModel>(
      child: Dice(),
      create: (BuildContext context) => DiceModel(),
    );
  }
}
class DiceModel with ChangeNotifier {
  int diceOne = 1;

  int get diceOneCount => diceOne;

  void generateDiceOne() {
    diceOne = Random().nextInt(5) + 1;
    print("diceOne: $diceOne");
    notifyListeners();
  }
}
