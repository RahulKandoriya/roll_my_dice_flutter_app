import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_my_dice/app/home/pages/empty_content.dart';
import 'package:roll_my_dice/constants/strings.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.data,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncValue<List<T>> data;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {

    print("Service data" + data.toString());
    return data.when(
      data: (items) =>
      items.isNotEmpty ? _buildList(items) : const EmptyContent(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const EmptyContent(
        title: Strings.somethingWentWrong,
        message: Strings.cantLoadItems,
      ),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}