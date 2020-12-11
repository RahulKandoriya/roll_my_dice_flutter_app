class FirestorePath {

  //LeaderBoard stats
  static String leaderBoardSingleData(String dataId) => 'leaderBoard/$dataId';
  static String leaderBoardData() => 'leaderBoard';

  //AppUser
  static String appUser(String uid) => 'appUsers/$uid';
}