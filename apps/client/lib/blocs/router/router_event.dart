part of 'router_bloc.dart';

abstract class RouterEvent extends Equatable {
  const RouterEvent();

  @override
  List<Object?> get props => [];
}

class RouterNavigateTo extends RouterEvent {
  final String location;
  final Map<String, dynamic>? arguments;

  const RouterNavigateTo(this.location, {this.arguments});

  @override
  List<Object?> get props => [location, arguments];
}

class RouterPop extends RouterEvent {
  final dynamic result;

  const RouterPop({this.result});

  @override
  List<Object?> get props => [result];
}

class RouterPushReplacement extends RouterEvent {
  final String location;
  final Map<String, dynamic>? arguments;

  const RouterPushReplacement(this.location, {this.arguments});

  @override
  List<Object?> get props => [location, arguments];
}

class RouterGoHome extends RouterEvent {
  const RouterGoHome();
}

class RouterLocationChanged extends RouterEvent {
  final String location;

  const RouterLocationChanged(this.location);

  @override
  List<Object> get props => [location];
}

class RouterHandleDeepLink extends RouterEvent {
  final String deepLink;

  const RouterHandleDeepLink(this.deepLink);

  @override
  List<Object> get props => [deepLink];
}

class RouterInitialize extends RouterEvent {
  final String initialLocation;

  const RouterInitialize({this.initialLocation = '/'});

  @override
  List<Object> get props => [initialLocation];
}
