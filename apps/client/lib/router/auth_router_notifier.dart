import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:board_games_empire/blocs/auth/auth_bloc.dart';
import 'package:board_games_empire/repositories/auth/auth_repository.dart';
import 'package:board_games_empire/router/app_router.dart';
import 'package:board_games_empire/router/route_constants.dart';

class AuthRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> _authSubscription;

  AuthRouterNotifier({required this.authBloc}) {
    _authSubscription = authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        if (AppRouter.router.state.path == AppRoutes.login) {
          AppRouter.router.canPop()
              ? AppRouter.router.pop()
              : AppRouter.router.go(AppRoutes.home);
        }
      } else if (state.status == AuthStatus.unauthenticated) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
