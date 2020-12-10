import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:roll_my_dice/app/home/pages/leaderBoard/list_item_builder.dart';
import 'package:roll_my_dice/app/home/pages/leaderBoard/list_item_tile.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:roll_my_dice/models/leaderBoardData.dart';


final leaderBoardStreamProvider = StreamProvider.autoDispose<List<LeaderBoardData>>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.leaderBoardStream() ?? const Stream.empty();
});

class LeaderBoardPage extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: _buildContents(context, watch),
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final leaderBoardStream = watch(leaderBoardStreamProvider);

    return ListItemsBuilder<LeaderBoardData>(
      data: leaderBoardStream,
      itemBuilder: (context, leaderBoardData) => ListItemTile( leaderBoardData: leaderBoardData,),
    );
  }
}
