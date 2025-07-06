import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:board_games_empire/blocs/auth/auth_bloc.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  AuthRouterNotifier({required this.authBloc}) {
    _authSubscription = authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
