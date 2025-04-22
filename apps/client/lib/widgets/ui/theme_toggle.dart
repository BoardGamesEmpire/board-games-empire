import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/settings/theme/theme_bloc.dart';
import '../../utils/extensions/theme_mode_extension.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(state.themeMode.icon),
          tooltip: 'Theme: ${state.themeMode.displayName}',
          onPressed: () => _showThemeSelectionDialog(context, state.themeMode),
        );
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context, ThemeMode currentTheme) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Choose theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ThemeMode.values.map((themeMode) {
                    return ListTile(
                      leading: Icon(themeMode.icon),
                      title: Text(themeMode.displayName),
                      trailing:
                          themeMode == currentTheme
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () {
                        context.read<ThemeBloc>().add(ThemeChanged(themeMode));
                        context.pop();
                      },
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }
}
