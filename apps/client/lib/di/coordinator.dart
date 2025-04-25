import 'dart:async';

import '../blocs/app/app_bloc.dart';
import '../blocs/app/initialization/app_initialization_bloc.dart';

class BlocCoordinator {
  final AppBloc appBloc;
  final AppInitializationBloc initializationBloc;
  late StreamSubscription _initStatusSubscription;

  BlocCoordinator({required this.appBloc, required this.initializationBloc}) {
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    _initStatusSubscription = initializationBloc.stream.listen((state) {
      if (state.status == AppInitializationStatus.success) {
        appBloc.add(
          AppInitialized(
            hasServers: state.serverInitialized,
            isAuthenticated: state.authInitialized,
            // TODO: get from state
            activeServer: null,
          ),
        );
      } else if (state.status == AppInitializationStatus.failure) {
        appBloc.add(AppError(state.error ?? 'Initialization failed'));
      }
    });
  }

  void dispose() {
    _initStatusSubscription.cancel();
  }
}
