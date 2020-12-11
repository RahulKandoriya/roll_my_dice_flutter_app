import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roll_my_dice/app/home/pages/account_page.dart';
import 'package:roll_my_dice/app/home/pages/userDetails/user_details_page.dart';


class AppRoutes {
  static const accountPage = '/account-page';
  static const userDetailsPage = '/userDetails-page';

}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {

      case AppRoutes.accountPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AccountPage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.userDetailsPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => UserDetailsPage( appUser: args,),
          settings: settings,
          fullscreenDialog: true,
        );

      default:
      // TODO: Throw
        return null;
    }
  }
}