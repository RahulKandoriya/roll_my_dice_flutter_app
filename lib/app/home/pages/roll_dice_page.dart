import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_my_dice/alert_dialogs/show_exception_dialog.dart';
import 'package:roll_my_dice/app/home/pages/empty_content.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:roll_my_dice/constants/strings.dart';
import 'package:roll_my_dice/models/appUser.dart';
import 'package:pedantic/pedantic.dart';
import 'package:roll_my_dice/models/leaderBoardData.dart';
import 'package:roll_my_dice/services/firestore_database.dart';

final appUserDetailsStreamProvider = StreamProvider.autoDispose<AppUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.appUserStream() ?? const Stream.empty();
});

final diceModelProvider = ChangeNotifierProvider.autoDispose<DiceModel>((ref) {
  return DiceModel();
});

class RollDicePage extends ConsumerWidget {

  Future<void> _updateUserDetails(BuildContext context, AppUser appUser, int randomNumber) async {
    try {
      final database = context.read(databaseProvider);
      appUser.numberOfAttempts++;
      appUser.score = appUser.score + randomNumber;
      await database.updateUserDetails(appUser);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  Future<void> _updateMaximumValues(BuildContext context, AppUser appUser, int maximumScore, int maximumAttempts) async {
    try {
      final database = context.read(databaseProvider);
      appUser.maximumScore = maximumScore;
      appUser.maximumAttempts = maximumAttempts;
      await database.updateUserDetails(appUser);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  Future<void> _resetAllValues(BuildContext context, AppUser appUser) async {
    try {
      final database = context.read(databaseProvider);
      appUser.maximumScore = 30;
      appUser.maximumAttempts = 10;
      appUser.numberOfAttempts = 0;
      appUser.score  = 0;
      await database.updateUserDetails(appUser);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  Future<void> _setScoreToLeaderBoard(BuildContext context, LeaderBoardData leaderBoardData) async {
    try {
      final database = context.read(databaseProvider);
      await database.setLeaderBoardSingleData(leaderBoardData);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final appUserStream = watch(appUserDetailsStreamProvider);
    final diceModel = watch(diceModelProvider);
    return appUserStream.when(
      data: (appUser) => __defaultPage(context, appUser, diceModel),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(
        body: EmptyContent(
          title: Strings.somethingWentWrong,
          message: Strings.cantLoadItems,
        ),
      ),
    );
  }

  Widget __defaultPage(BuildContext context, AppUser appUser, DiceModel diceModel) {

    List<String> _diceOneImages = [
      "assets/images/dice1.png",
      "assets/images/dice2.png",
      "assets/images/dice3.png",
      "assets/images/dice4.png",
      "assets/images/dice5.png",
      "assets/images/dice6.png",
    ];
    final dice = diceModel;
    final c = dice.diceOneCount;
    var img = Image.asset(
      _diceOneImages[c - 1],
      gaplessPlayback: true,
    );


    TextEditingController maximumScore = TextEditingController(text: appUser.maximumScore.toString());
    TextEditingController maximumAttempts = TextEditingController(text: appUser.maximumAttempts.toString());

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox( height: 50,),

              Text("Roll your dice and Win!",
                style: TextStyle( fontSize: 30, color: Colors.black),
              ),
              SizedBox( height: 20,),
              Container(
                margin: EdgeInsets.only( left: 16, bottom: 24, right: 16),
                padding: EdgeInsets.only( top: 16, bottom: 16, right: 16, left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 4,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Update maximum values",
                      style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text("Score: " + appUser.maximumScore.toString(),
                      style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text("Attempts: " + appUser.maximumAttempts.toString(),
                      style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Score:",
                          style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox( width: 20,),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            controller: maximumScore,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Attempts:",
                          style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox( width: 20,),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(2),
                            ],
                            controller: maximumAttempts,

                          ),
                        )
                      ],
                    ),
                    SizedBox( height: 20,),
                    RaisedButton(
                        onPressed: () {

                          if(int.parse(maximumScore.text) < 6 || int.parse(maximumAttempts.text) < 1){
                          } else {
                            _updateMaximumValues(context, appUser, int.parse(maximumScore.text), int.parse(maximumAttempts.text));
                          }
                        },
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Update Values",
                            style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              img,
              SizedBox( height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(appUser.score.toString(),
                        style: TextStyle( fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("is your Score",
                        style: TextStyle( fontSize: 30, color: Colors.black),
                      ),
                      SizedBox( height: 5,),
                      Text("Your Score is the sum of\nthe the total attempts\n\nIf the difference between maximum values is low\nthen logic won't work\n",
                        style: TextStyle( fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox( height: 30,),
                      Text((appUser.maximumAttempts - appUser.numberOfAttempts).toString() + " Attempt(s) remained.",
                        style: TextStyle( fontSize: 25, color: Colors.black),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox( height: 50,),
              RaisedButton(
                  onPressed: appUser.maximumAttempts - appUser.numberOfAttempts == 0 ? null : () {
                    //player.play('/audio/diceroll_sound.mp3');

                    final scoreDifference  = appUser.maximumScore - appUser.score;
                    final numberOfAttemptsDifference = appUser.maximumAttempts - appUser.numberOfAttempts;
                    if( scoreDifference > 6 ){
                      //if the score difference is more than 6 then all the dice outcome will be allowed.
                      updateDices(dice, 5);
                    } else {
                      if(numberOfAttemptsDifference < scoreDifference) {

                        //if the score difference is more than the numberOfAttempts then the allowed dice outcomes are
                        // (scoreDifference - 2) and -2 because score difference should not be dice outcome in one attempt

                        updateDices(dice, scoreDifference - 2);
                      } else {

                        //if the score difference is less than the number of attempts then the dice outcome should be (numberOfAttemptsDifference - 2)
                        updateDices(dice, numberOfAttemptsDifference - 2);
                      }
                    }

                    print(scoreDifference.toString() + " " + numberOfAttemptsDifference.toString());

                    _updateUserDetails(context, appUser, dice.diceOneCount);

                    if (appUser.maximumAttempts - appUser.numberOfAttempts == 0) {
                      _setScoreToLeaderBoard(context, LeaderBoardData(id: documentIdFromCurrentDate(), name: appUser.name, score: appUser.score));
                    }
                  },
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Roll the dice",
                      style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
                    ),
                  )
              ),
              SizedBox( height: 20,),
              RaisedButton(
                  onPressed: (){
                    _resetAllValues(context, appUser);
                  },
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Reset All Values",
                      style: TextStyle( fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
                    ),
                  )
              ),
              SizedBox( height: 50,),
            ],
          )
        ],
      ),
    );
  }

  void updateDices(DiceModel dice, int maxNumber) async {
    dice.generateDiceOne(maxNumber);
  }


}

class DiceModel with ChangeNotifier {
  int diceOne = 1;
  int get diceOneCount => diceOne;

  void generateDiceOne(int maxNumber) {

    if(maxNumber <=1) {
      //when the maxNumber is less than or equal to 1 then only one dice outcome is allowed that is 1
      diceOne = 1;
    } else {
      diceOne = Random().nextInt(maxNumber) + 1;
    }
    print("diceOne: $diceOne");
    notifyListeners();
  }
}

