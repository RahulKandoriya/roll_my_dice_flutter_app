import 'package:flutter/material.dart';
import 'package:roll_my_dice/constants/keys.dart';
import 'package:roll_my_dice/constants/strings.dart';

enum TabItem { rollDice, leaderBoard, account }

class TabItemData {
  const TabItemData(
      {@required this.key, @required this.title, @required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.rollDice: TabItemData(
      key: Keys.rollDiceTab,
      title: Strings.rollDice,
      icon: Icons.dashboard,
    ),
    TabItem.leaderBoard: TabItemData(
      key: Keys.leaderBoardTab,
      title: Strings.leaderBoard,
      icon: Icons.list,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),

  };
}