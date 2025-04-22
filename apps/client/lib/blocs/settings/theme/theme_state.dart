part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.systemBrightness = Brightness.light,
  });

  final ThemeMode themeMode;
  final Brightness systemBrightness;

  ThemeState copyWith({ThemeMode? themeMode, Brightness? systemBrightness}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      systemBrightness: systemBrightness ?? this.systemBrightness,
    );
  }

  Brightness get effectiveBrightness {
    if (themeMode == ThemeMode.system) {
      return systemBrightness;
    }
    return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }

  bool get isDarkMode => effectiveBrightness == Brightness.dark;

  @override
  List<Object> get props => [themeMode, systemBrightness];
}
