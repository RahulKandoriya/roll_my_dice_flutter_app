import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:roll_my_dice/alert_dialogs/show_alert_dialog.dart';
import 'package:roll_my_dice/alert_dialogs/show_exception_dialog.dart';
import 'package:roll_my_dice/app/home/pages/empty_content.dart';
import 'package:roll_my_dice/app/home/pages/userDetails/user_details_page.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:roll_my_dice/constants/strings.dart';
import 'package:roll_my_dice/models/appUser.dart';
import 'package:pedantic/pedantic.dart';


final appUserDetailsStreamProvider = StreamProvider.autoDispose<AppUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database?.appUserStream() ?? const Stream.empty();
});

class AccountPage extends ConsumerWidget {

  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: Strings.logoutFailed,
        exception: e,
      ));
    }
  }

  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
      context: context,
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final appUserDetailsStream = watch(appUserDetailsStreamProvider);
    final firebaseAuth = context.read(firebaseAuthProvider);
    return appUserDetailsStream.when(
      data: (appUser) => _buildAccountPage(context, appUser, firebaseAuth),
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

  Widget _buildAccountPage(BuildContext context, AppUser appUser, FirebaseAuth firebaseAuth){
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle, size: 100, color: Colors.grey,)
                ],
              ),
              SizedBox( height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Name:",
                                style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox( width: 20,),
                              Text(appUser.name,
                                style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Phone:",
                                style: TextStyle( fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox( width: 20,),
                              Text(appUser.phoneNumber,
                                style: TextStyle( fontWeight: FontWeight.normal, fontSize: 18),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Version:",
                                style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox( width: 20,),
                              Text("2.0.0.1",
                                style: TextStyle( fontWeight: FontWeight.normal, fontSize: 18),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox( height: 30,),
              Container(
                height: 0.5,
                color: Colors.grey,
              ),
              Material(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserDetailsPage( appUser: appUser,)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only( left: 16, right: 16, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox( width: 12,),
                        Expanded(
                          child: Text(Strings.editUserDetails,
                            style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.grey,),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () => _confirmSignOut(context, firebaseAuth),
                  child: Container(
                    padding: EdgeInsets.only( left: 16, right: 24, top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox( width: 12,),
                        Expanded(
                          child: Text(Strings.logout.toUpperCase(),
                            style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

}
