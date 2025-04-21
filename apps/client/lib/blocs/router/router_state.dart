part of 'router_bloc.dart';

enum NavigationMethod { none, push, pop, replace, goToRoot }

class RouterState extends Equatable {
  final String location;
  final NavigationMethod navigationMethod;
  final Map<String, dynamic>? navigationArgs;
  final dynamic navigationResult;
  final bool isInitialized;

  const RouterState({
    required this.location,
    this.navigationMethod = NavigationMethod.none,
    this.navigationArgs,
    this.navigationResult,
    this.isInitialized = false,
  });

  const RouterState.initial()
    : location = '/',
      navigationMethod = NavigationMethod.none,
      navigationArgs = null,
      navigationResult = null,
      isInitialized = false;

  RouterState copyWith({
    String? location,
    NavigationMethod? navigationMethod,
    Map<String, dynamic>? navigationArgs,
    dynamic navigationResult,
    bool? isInitialized,
  }) {
    return RouterState(
      location: location ?? this.location,
      navigationMethod: navigationMethod ?? this.navigationMethod,
      navigationArgs: navigationArgs ?? this.navigationArgs,
      navigationResult: navigationResult ?? this.navigationResult,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
    location,
    navigationMethod,
    navigationArgs,
    navigationResult,
    isInitialized,
  ];
}
