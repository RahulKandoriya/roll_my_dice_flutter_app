import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
// ignore: must_be_immutable
class LeaderBoardData extends Equatable {
  LeaderBoardData(
      {@required this.id, @required this.score,});
  final String id;
  final int score;

  @override
  List<Object> get props => [id,score,];

  @override
  bool get stringify => true;

  factory LeaderBoardData.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }

    final score = data['score'] as int;
    return LeaderBoardData(id: id, score: score,);
  }

  Map<String, dynamic> toMap() {
    return {
      'score' : score,
    };
  }
}