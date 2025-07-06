import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/app/app_bloc.dart';
import '../../blocs/app/initialization/app_initialization_bloc.dart';
import '../../router/route_constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppInitializationBloc, AppInitializationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {},
        ),

        BlocListener<AppBloc, AppState>(
          listenWhen:
              (previous, current) =>
                  !previous.isInitialized && current.isInitialized,
          listener: (context, state) {
            if (state.isInitialized) {
              _navigateBasedOnAppState(context, state);
            }
          },
        ),
      ],
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
          child: BlocBuilder<AppInitializationBloc, AppInitializationState>(
            buildWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.progress != current.progress ||
                    previous.error != current.error,
            builder: (context, state) {
              if (state.hasError) {
                return _buildErrorView(context, state.error!);
              }

              return _buildLoadingView(context, state.progress);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context, double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo
        Image.asset('assets/images/logo.png', width: 150, height: 150),
        const SizedBox(height: 32),

        // App name
        Text(
          'Board Games Empire',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 48),

        // Progress indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 16),

        // Loading text
        Text(
          'Loading...',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 80, color: Colors.white),
        const SizedBox(height: 24),

        Text(
          'Initialization Error',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            error,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () => _retryInitialization(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  void _retryInitialization(BuildContext context) {
    context.read<AppInitializationBloc>().add(const AppInitStarted());
  }

  void _navigateBasedOnAppState(BuildContext context, AppState state) {
    switch (state.status) {
      case AppStatus.needsServerSetup:
        context.goNamed(
          AppRouteNames.serverConfig,
          queryParameters: {'initial': true},
        );
        break;
      case AppStatus.unauthenticated:
        context.goNamed(AppRouteNames.login);
        break;
      case AppStatus.authenticated:
        context.goNamed(AppRouteNames.home);
        break;
      case AppStatus.error:
        break;
      default:
        break;
    }
  }
}
