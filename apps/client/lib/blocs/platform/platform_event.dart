part of 'platform_bloc.dart';

abstract class PlatformEvent extends Equatable {
  const PlatformEvent();

  @override
  List<Object?> get props => [];
}

class PlatformInitialized extends PlatformEvent {
  const PlatformInitialized();
}

class PlatformWebBaseUrlRequested extends PlatformEvent {
  const PlatformWebBaseUrlRequested();
}
