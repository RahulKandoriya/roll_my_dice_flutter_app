import 'package:flutter/material.dart';
import 'package:roll_my_dice/constants/strings.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = Strings.nothingHere,
    this.message = Strings.noData,
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 32.0, color: Colors.black54),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
