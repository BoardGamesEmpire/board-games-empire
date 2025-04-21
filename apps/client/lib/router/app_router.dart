import 'package:go_router/go_router.dart';

import '../blocs/router/router_bloc.dart';
import '../di/injection.dart';
import './bloc_router_delegate.dart';

class AppRouter {
  static late final BlocRouterDelegate _routerDelegate;
  static late final GoRouter router;

  static void initialize() {
    _routerDelegate = BlocRouterDelegate();
    router = _routerDelegate.router;

    // Initialize RouterBloc with default location
    getIt<RouterBloc>().add(const RouterInitialize(initialLocation: '/'));
  }

  // Navigation methods that should be used throughout the app
  static void navigateTo(String location, {Map<String, dynamic>? arguments}) {
    getIt<RouterBloc>().add(RouterNavigateTo(location, arguments: arguments));
  }

  static void replaceTo(String location, {Map<String, dynamic>? arguments}) {
    getIt<RouterBloc>().add(
      RouterPushReplacement(location, arguments: arguments),
    );
  }

  static void pop<T>([T? result]) {
    getIt<RouterBloc>().add(RouterPop(result: result));
  }

  static void goHome() {
    getIt<RouterBloc>().add(const RouterGoHome());
  }

  static void handleDeepLink(String deepLink) {
    getIt<RouterBloc>().add(RouterHandleDeepLink(deepLink));
  }
}
