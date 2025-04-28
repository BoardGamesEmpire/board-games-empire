import 'package:flutter/material.dart';

/// A reusable container for forms that provides consistent padding,
/// scrolling behavior, and layout for form screens across the app.
class FormContainer extends StatelessWidget {
  final List<Widget> children;

  final String? title;

  final String? subtitle;

  final Widget? headerIcon;

  final double fieldSpacing;

  final EdgeInsetsGeometry padding;

  final bool centerContent;

  final CrossAxisAlignment crossAxisAlignment;

  const FormContainer({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.headerIcon,
    this.fieldSpacing = 16.0,
    this.padding = const EdgeInsets.all(24.0),
    this.centerContent = true,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                centerContent
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              if (headerIcon != null) ...[
                headerIcon!,
                SizedBox(height: fieldSpacing),
              ],

              if (title != null) ...[
                Text(
                  title!,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: fieldSpacing / 2),
              ],

              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: fieldSpacing * 1.5),
              ],

              ...List.generate(children.length * 2 - 1, (index) {
                if (index.isEven) {
                  return children[index ~/ 2];
                }

                return SizedBox(height: fieldSpacing);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
