import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final String text;

  const TypingIndicator({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const _TypingDots(),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated typing dots indicator
class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  _TypingDotsState createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _animControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _animControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: Duration(milliseconds: 150 + (index * 100)),
        vsync: this,
      ),
    );

    _animations =
        _animControllers.map((controller) {
          return Tween<double>(begin: 0, end: 6).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    _startAnimation();
  }

  void _startAnimation() {
    for (var i = 0; i < _animControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(3),
              ),
              transform:
                  Transform.translate(
                    offset: Offset(0, -_animations[index].value),
                  ).transform,
            );
          },
        );
      }),
    );
  }
}
