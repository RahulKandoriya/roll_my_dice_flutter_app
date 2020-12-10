import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
// ignore: must_be_immutable
class LeaderBoardData extends Equatable {
  const LeaderBoardData(
      {@required this.id,@required this.name, @required this.score,});
  final String id;
  final String name;
  final int score;

  @override
  List<Object> get props => [id,name, score,];

  @override
  bool get stringify => true;

  factory LeaderBoardData.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }

    final name  = data['name'] as String;
    final score = data['score'] as int;
    return LeaderBoardData(id: id, name: name, score: score,);
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'score' : score,
    };
  }
}