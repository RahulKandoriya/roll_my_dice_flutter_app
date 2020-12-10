import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
// ignore: must_be_immutable
class AppUser extends Equatable {
  AppUser(
      {@required this.id, @required this.numberOfAttempts, @required this.score,});
  final String id;
  int numberOfAttempts;
  int score;

  @override
  List<Object> get props => [id, numberOfAttempts,score,];

  @override
  bool get stringify => true;

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }
    final numberOfAttempts = data['numberOfAttempts'] as int;
    if (numberOfAttempts == null) {
      return null;
    }

    final score = data['score'] as int;
    return AppUser(id: id, numberOfAttempts: numberOfAttempts, score: score,);
  }

  Map<String, dynamic> toMap() {
    return {
      'numberOfAttempts': numberOfAttempts,
      'score' : score,
    };
  }
}