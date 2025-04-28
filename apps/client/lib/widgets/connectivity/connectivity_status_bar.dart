import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import './connectivity_indicator.dart';

/// A status bar that shows connectivity status at the top of the app
class ConnectivityStatusBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;

  final List<Widget>? actions;

  final bool automaticallyImplyLeading;

  final Color? backgroundColor;

  final double elevation;

  final bool showInternetBanner;

  final PreferredSizeWidget? bottom;

  const ConnectivityStatusBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation = 0,
    this.showInternetBanner = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize
              .min, // Add this to prevent Column from expanding infinitely
      children: [
        AppBar(
          title: title,
          actions: [
            ...(actions ?? []),
            const SizedBox(width: 8),
            const ConnectivityIndicator(compact: true),
            const SizedBox(width: 16),
          ],
          automaticallyImplyLeading: automaticallyImplyLeading,
          backgroundColor: backgroundColor,
          elevation: elevation,
          bottom: bottom,
        ),
        if (showInternetBanner)
          BlocBuilder<AppBloc, AppState>(
            buildWhen:
                (previous, current) =>
                    previous.hasInternetConnection !=
                    current.hasInternetConnection,
            builder: (context, state) {
              if (!state.hasInternetConnection) {
                return Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 16,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 14),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No internet connection',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    // Standard AppBar height (56) plus potential banner height + bottom height if present
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(56 + (showInternetBanner ? 24 : 0) + bottomHeight);
  }
}
