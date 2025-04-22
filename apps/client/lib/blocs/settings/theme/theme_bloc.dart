import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _preferences;
  static const String _themeKey = 'app_theme_mode';

  ThemeBloc({required SharedPreferences preferences})
    : _preferences = preferences,
      super(const ThemeState()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
    on<SystemThemeChanged>(_onSystemThemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeIndex = _preferences.getInt(_themeKey);
    ThemeMode themeMode;

    if (savedThemeIndex != null) {
      themeMode = ThemeMode.values[savedThemeIndex];
    } else {
      themeMode = ThemeMode.system;
    }

    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await _preferences.setInt(_themeKey, event.themeMode.index);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onSystemThemeChanged(
    SystemThemeChanged event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(systemBrightness: event.brightness));
  }
}
