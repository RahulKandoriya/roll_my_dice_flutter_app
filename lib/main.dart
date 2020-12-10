import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roll_my_dice/app/auth_widget.dart';
import 'package:roll_my_dice/app/home/home_page.dart';
import 'package:roll_my_dice/app/sign_in/sign_in_page.dart';
import 'package:roll_my_dice/app/top_level_providers.dart';
import 'package:roll_my_dice/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that don't depend on any runtime values (e.g. uid)
    final firebaseAuth = context.read(firebaseAuthProvider);
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) => SignInPage(),
        signedInBuilder: (_) => HomePage(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}

