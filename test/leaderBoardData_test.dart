import 'package:flutter_test/flutter_test.dart';
import 'package:roll_my_dice/models/leaderBoardData.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final leaderBoardData = LeaderBoardData.fromMap(null, 'abc');
      expect(leaderBoardData, null);
    });
    test('leaderBoardData with all properties', () {
      final leaderBoardData = LeaderBoardData.fromMap(const {
        'name': 'Mitesh',
        'score': 10,
      }, 'abc');
      expect(leaderBoardData, const LeaderBoardData(name: 'Mitesh', score: 10, id: 'abc'));
    });

    test('missing name', () {
      final leaderBoardData = LeaderBoardData.fromMap(const {
        'score': 10,
      }, 'abc');
      expect(leaderBoardData, null);
    });
  });

  group('toMap', () {
    test('valid name, score', () {
      const leaderBoardData = LeaderBoardData(name: 'Mitesh', score: 10, id: 'abc');
      expect(leaderBoardData.toMap(), {
        'name': 'Mitesh',
        'score': 10,
      });
    });
  });

  group('equality', () {
    test('different properties, equality returns false', () {
      const leaderBoardData1 = LeaderBoardData(name: 'Mitesh', score: 10, id: 'abc');
      const leaderBoardData2 = LeaderBoardData(name: 'Mitesh', score: 5, id: 'abc');
      expect(leaderBoardData1 == leaderBoardData2, false);
    });
    test('same properties, equality returns true', () {
      const leaderBoardData1 = LeaderBoardData(name: 'Mitesh', score: 10, id: 'abc');
      const leaderBoardData2 = LeaderBoardData(name: 'Mitesh', score: 10, id: 'abc');
      expect(leaderBoardData1 == leaderBoardData2, true);
    });
  });
}