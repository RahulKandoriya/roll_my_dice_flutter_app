import 'dart:async';
import 'package:meta/meta.dart';
import 'package:roll_my_dice/models/appUser.dart';
import 'package:roll_my_dice/models/leaderBoardData.dart';
import './firestore_service.dart';
import './firebase_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid})
      : assert(uid != null, 'Cannot create FirestoreDatabase with null uid');
  final String uid;

  final _service = FirestoreService.instance;

  //AppUser Details

  Future<void> setUserDetails(AppUser appUser) => _service.setData(
    path: FirestorePath.appUser(uid),
    data: appUser.toMap(),
  );

  Future<AppUser> getUserDetails() => _service.getData(
    path: FirestorePath.appUser(uid),
  );

  Future<void> updateUserDetails(AppUser appUser) => _service.updateData(
    path: FirestorePath.appUser(uid),
    data: appUser.toMap(),
  );

  Stream<AppUser> appUserStream() => _service.documentStream(
    path: FirestorePath.appUser(uid),
    builder: (data, documentId) => AppUser.fromMap(data, documentId),
  );

  //LeaderBoardData

  Future<void> setLeaderBoardSingleData(LeaderBoardData leaderBoardData) => _service.setData(
    path: FirestorePath.leaderBoardSingleData(leaderBoardData.id),
    data: leaderBoardData.toMap(),
  );

  Stream<List<LeaderBoardData>> leaderBoardStream() => _service.leaderBoardCollectionStream(
    path: FirestorePath.leaderBoardData(),
    builder: (data, documentId) => LeaderBoardData.fromMap(data, documentId),
  );


}