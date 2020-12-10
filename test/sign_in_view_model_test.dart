import 'dart:async';

import 'package:roll_my_dice/app/sign_in/sign_in_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  SignInViewModel viewModel;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    viewModel = SignInViewModel(auth: mockFirebaseAuth);
  });

  tearDown(() {
    mockFirebaseAuth = null;
    viewModel = null;
  });
}