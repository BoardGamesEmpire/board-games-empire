part of 'platform_bloc.dart';

class PlatformState extends Equatable {
  final bool isWeb;
  final bool isMobile;
  final bool isDesktop;
  final String platformName;
  final String webBaseUrl;
  final Map<String, dynamic> webLocationDetails;
  final String? webError;
  final bool isInitialized;

  const PlatformState({
    required this.isWeb,
    required this.isMobile,
    required this.isDesktop,
    required this.platformName,
    required this.webBaseUrl,
    required this.webLocationDetails,
    this.webError,
    required this.isInitialized,
  });

  factory PlatformState.initial() {
    return const PlatformState(
      isWeb: kIsWeb,
      isMobile: false,
      isDesktop: false,
      platformName: 'Unknown',
      webBaseUrl: '',
      webLocationDetails: {},
      webError: null,
      isInitialized: false,
    );
  }

  PlatformState copyWith({
    bool? isWeb,
    bool? isMobile,
    bool? isDesktop,
    String? platformName,
    String? webBaseUrl,
    Map<String, dynamic>? webLocationDetails,
    String? webError,
    bool? isInitialized,
  }) {
    return PlatformState(
      isWeb: isWeb ?? this.isWeb,
      isMobile: isMobile ?? this.isMobile,
      isDesktop: isDesktop ?? this.isDesktop,
      platformName: platformName ?? this.platformName,
      webBaseUrl: webBaseUrl ?? this.webBaseUrl,
      webLocationDetails: webLocationDetails ?? this.webLocationDetails,
      webError: webError,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
    isWeb,
    isMobile,
    isDesktop,
    platformName,
    webBaseUrl,
    webLocationDetails,
    webError,
    isInitialized,
  ];
}
