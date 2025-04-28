import 'package:flutter/material.dart';

/// A widget that shows a loading indicator over its child when isLoading is true.
class LoadingOverlay extends StatelessWidget {
  final Widget child;

  final bool isLoading;

  final String? loadingText;

  final Color overlayColor;

  final double opacity;

  final double indicatorSize;

  final Color? indicatorColor;

  final Widget? indicator;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
    this.overlayColor = Colors.black,
    this.opacity = 0.5,
    this.indicatorSize = 40.0,
    this.indicatorColor,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIndicatorColor =
        indicatorColor ?? Theme.of(context).primaryColor;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor.withOpacity(opacity),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    indicator ??
                        SizedBox(
                          width: indicatorSize,
                          height: indicatorSize,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              effectiveIndicatorColor,
                            ),
                          ),
                        ),
                    if (loadingText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        loadingText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A circular loading indicator with optional text
class CircularLoading extends StatelessWidget {
  /// The loading text to display
  final String? text;

  /// The size of the loading indicator
  final double size;

  /// The color of the loading indicator
  final Color? color;

  /// The stroke width of the circular progress indicator
  final double strokeWidth;

  /// Whether to center the loading indicator within its parent
  final bool centered;

  const CircularLoading({
    super.key,
    this.text,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 4.0,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).primaryColor;

    final loadingWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        ),
        if (text != null) ...[const SizedBox(height: 16), Text(text!)],
      ],
    );

    if (centered) {
      return Center(child: loadingWidget);
    }

    return loadingWidget;
  }
}
