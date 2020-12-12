import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
// ignore: must_be_immutable
class AppUser extends Equatable {
  AppUser(
      {@required this.id, @required this.name, @required this.phoneNumber, @required this.email, @required this.numberOfAttempts, @required this.score,});
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  int numberOfAttempts;
  int score;

  @override
  List<Object> get props => [id, name, phoneNumber, email, numberOfAttempts,score,];

  @override
  bool get stringify => true;

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return null;
    }

    final name = data['name'] as String;
    final phoneNumber = data['phoneNumber'] as String;
    final email = data['email'] as String;
    final numberOfAttempts = data['numberOfAttempts'] as int;
    final score = data['score'] as int;
    return AppUser(id: id, name: name, phoneNumber: phoneNumber, email: email, numberOfAttempts: numberOfAttempts, score: score,);
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'phoneNumber': phoneNumber,
      'email' : email,
      'numberOfAttempts': numberOfAttempts,
      'score' : score,
    };
  }
}