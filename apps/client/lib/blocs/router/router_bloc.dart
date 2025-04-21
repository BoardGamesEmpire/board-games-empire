import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../router/route_constants.dart';

part 'router_event.dart';
part 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  RouterBloc() : super(const RouterState.initial()) {
    on<RouterNavigateTo>(_onNavigateTo);
    on<RouterPop>(_onPop);
    on<RouterPushReplacement>(_onPushReplacement);
    on<RouterGoHome>(_onGoHome);
    on<RouterLocationChanged>(_onLocationChanged);
    on<RouterHandleDeepLink>(_onHandleDeepLink);
    on<RouterInitialize>(_onInitialize);
  }

  void _onNavigateTo(RouterNavigateTo event, Emitter<RouterState> emit) {
    emit(
      state.copyWith(
        location: event.location,
        navigationMethod: NavigationMethod.push,
        navigationArgs: event.arguments,
      ),
    );
  }

  void _onPop(RouterPop event, Emitter<RouterState> emit) {
    emit(
      state.copyWith(
        navigationMethod: NavigationMethod.pop,
        navigationResult: event.result,
      ),
    );
  }

  void _onPushReplacement(
    RouterPushReplacement event,
    Emitter<RouterState> emit,
  ) {
    emit(
      state.copyWith(
        location: event.location,
        navigationMethod: NavigationMethod.replace,
        navigationArgs: event.arguments,
      ),
    );
  }

  void _onGoHome(RouterGoHome event, Emitter<RouterState> emit) {
    emit(
      state.copyWith(
        location: AppRoutes.home,
        navigationMethod: NavigationMethod.goToRoot,
      ),
    );
  }

  void _onLocationChanged(
    RouterLocationChanged event,
    Emitter<RouterState> emit,
  ) {
    emit(
      state.copyWith(
        location: event.location,
        navigationMethod: NavigationMethod.none,
      ),
    );
  }

  void _onHandleDeepLink(
    RouterHandleDeepLink event,
    Emitter<RouterState> emit,
  ) {
    // Parse deep link and determine appropriate route
    final Uri uri = Uri.parse(event.deepLink);
    final String path = uri.path;
    final Map<String, String> queryParams = uri.queryParameters;

    // Handle specific deep links here
    // For example, game details: /games/{id}
    if (path.startsWith('/games/') && path.length > 7) {
      final String gameId = path.substring(7);
      emit(
        state.copyWith(
          location: AppRoutes.buildGameDetailsPath(gameId),
          navigationMethod: NavigationMethod.push,
          navigationArgs: queryParams,
        ),
      );
    } else {
      // Default handling
      emit(
        state.copyWith(
          location: path,
          navigationMethod: NavigationMethod.push,
          navigationArgs: queryParams,
        ),
      );
    }
  }

  void _onInitialize(RouterInitialize event, Emitter<RouterState> emit) {
    emit(state.copyWith(location: event.initialLocation, isInitialized: true));
  }
}
