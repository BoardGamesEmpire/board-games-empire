import 'package:flutter/material.dart';

/// A widget that shows a linear progress indicator at the top of the screen
class TopLinearProgress extends StatelessWidget {
  final double? value;

  final double height;

  final Color? color;

  final Color? backgroundColor;

  const TopLinearProgress({
    super.key,
    this.value,
    this.height = 4.0,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surface.withOpacity(0.2);

    return SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        backgroundColor: effectiveBackgroundColor,
      ),
    );
  }
}
