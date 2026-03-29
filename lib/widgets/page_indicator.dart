import 'package:flutter/material.dart';

/// Animated page indicator dots used by carousel-style PageViews.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    super.key,
  });

  final int count;
  final int currentIndex;
  final Color activeColor;

  /// Alpha applied to the active color for inactive dots (~30% opacity).
  static const int _inactiveAlpha = 77;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                isActive ? activeColor : activeColor.withAlpha(_inactiveAlpha),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
