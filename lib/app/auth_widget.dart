import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.signedInBuilder,
    @required this.nonSignedInBuilder,
  }) : super(key: key);
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) => _data(context, user, watch),
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

  Widget _data(BuildContext context, User user, ScopedReader watch) {
    if (user != null) {
      return homePageBuilder(context, watch, user);
    }
    return nonSignedInBuilder(context);
  }

  Widget homePageBuilder(BuildContext context, ScopedReader watch, User user) {
    final appUserDetailsStream = watch(appUserDetailsStreamProvider);
    return appUserDetailsStream.when(
      data: (appUser) => _homePageData(context, appUser, user),
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

  Widget _homePageData(BuildContext context, AppUser appUser, User user) {
    if (appUser != null) {

      return signedInBuilder(context);
    }
    final newAppUser = AppUser(id: user.uid,
        name: null,
        phoneNumber: user.phoneNumber != null ? user.phoneNumber : "Not provided",
        email: user.email != null ? user.email : "Not provided",
        numberOfAttempts: 0,
        score: 0,
        maximumAttempts: 10,
        maximumScore: 30,
    );
    return UserDetailsPage( appUser: newAppUser,);
  }
}