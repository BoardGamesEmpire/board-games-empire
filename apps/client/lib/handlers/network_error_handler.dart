import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../blocs/error/error_bloc.dart';

class NetworkErrorHandler {
  final ErrorBloc _errorBloc;
  final Connectivity _connectivity;
  StreamSubscription? _connectivitySubscription;
  bool _wasConnected = true;

  NetworkErrorHandler({
    required ErrorBloc errorBloc,
    Connectivity? connectivity,
  }) : _errorBloc = errorBloc,
       _connectivity = connectivity ?? Connectivity();

  void initialize() {
    _checkInitialConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _wasConnected = result != ConnectivityResult.none;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking initial connectivity: $e');
      }
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isEmpty) return;
    final isConnected = results.first != ConnectivityResult.none;

    // Only report when going from connected to disconnected
    if (_wasConnected && !isConnected) {
      _errorBloc.add(
        const NetworkErrorReported(
          'Network connection lost. Please check your internet connection.',
        ),
      );
    } else if (!_wasConnected && isConnected) {
      // Connection restored
      _errorBloc.add(const ErrorDismissed());
    }

    _wasConnected = isConnected;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
