import 'package:flutter/cupertino.dart';
import 'package:roll_my_dice/app/home/cupertino_home_scaffold.dart';
import 'package:roll_my_dice/app/home/pages/account_page.dart';
import 'file:///C:/Users/Rahul/StudioProjects/roll_my_dice/lib/app/home/pages/leaderBoard/leaderboard_page.dart';
import 'package:roll_my_dice/app/home/pages/roll_dice_page.dart';
import 'package:roll_my_dice/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.rollDice;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.rollDice: GlobalKey<NavigatorState>(),
    TabItem.leaderBoard: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.rollDice: (_) => RollDicePage(),
      TabItem.leaderBoard: (_) => LeaderBoardPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
      !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}