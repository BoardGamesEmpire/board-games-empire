import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/settings/theme/theme_bloc.dart';
import '../../utils/extensions/theme_mode_extension.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildThemeCard(
                context,
                ThemeMode.system,
                state.themeMode == ThemeMode.system,
              ),
              const SizedBox(height: 12),
              _buildThemeCard(
                context,
                ThemeMode.light,
                state.themeMode == ThemeMode.light,
              ),
              const SizedBox(height: 12),
              _buildThemeCard(
                context,
                ThemeMode.dark,
                state.themeMode == ThemeMode.dark,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    ThemeMode themeMode,
    bool isSelected,
  ) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isSelected
                ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
                : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.read<ThemeBloc>().add(ThemeChanged(themeMode));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                themeMode.icon,
                size: 32,
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeMode.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getThemeModeDescription(themeMode),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeModeDescription(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'Follow your device settings';
      case ThemeMode.light:
        return 'Always use light theme';
      case ThemeMode.dark:
        return 'Always use dark theme';
    }
  }
}
