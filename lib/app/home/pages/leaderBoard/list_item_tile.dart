import 'package:flutter/material.dart';
import 'package:roll_my_dice/models/leaderBoardData.dart';

class ListItemTile extends StatelessWidget {
  const ListItemTile({Key key, @required this.leaderBoardData})
      : super(key: key);
  final LeaderBoardData leaderBoardData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(leaderBoardData.name.toString()),
      trailing: Text(leaderBoardData.score.toString()),
    );
  }
}

