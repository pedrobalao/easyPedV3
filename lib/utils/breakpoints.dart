import 'package:flutter/material.dart';

/// Material 3 window-size class breakpoints.
///
/// Compact  : width < 600 px   (phones in portrait)
/// Medium   : 600 ≤ width < 1200 px (tablets, phones in landscape)
/// Expanded : width ≥ 1200 px  (desktops, large tablets)
enum WindowSizeClass { compact, medium, expanded }

/// Returns the [WindowSizeClass] for the current screen width.
WindowSizeClass windowSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return WindowSizeClass.compact;
  if (width < 1200) return WindowSizeClass.medium;
  return WindowSizeClass.expanded;
}

/// Returns `true` when the screen width is below 600 px (compact).
bool isCompact(BuildContext context) =>
    windowSizeOf(context) == WindowSizeClass.compact;

/// Returns `true` when the screen width is between 600 and 1200 px (medium).
bool isMedium(BuildContext context) =>
    windowSizeOf(context) == WindowSizeClass.medium;

/// Returns `true` when the screen width is 1200 px or above (expanded).
bool isExpanded(BuildContext context) =>
    windowSizeOf(context) == WindowSizeClass.expanded;
