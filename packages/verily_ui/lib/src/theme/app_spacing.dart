import 'package:flutter/widgets.dart';

/// Defines standard spacing values used throughout the Verily apps.
/// Helps maintain visual consistency.
class AppSpacing {
  AppSpacing._(); // Private constructor

  // Base spacing unit
  static const double _base = 8.0;

  /// Extra Small: 4.0
  static const double xs = 0.5 * _base;

  /// Small: 8.0
  static const double sm = 1.0 * _base;

  /// Medium: 12.0
  static const double md = 1.5 * _base;

  /// Large: 16.0
  static const double lg = 2.0 * _base;

  /// Extra Large: 24.0
  static const double xl = 3.0 * _base;

  /// Extra Extra Large: 32.0
  static const double xxl = 4.0 * _base;

  /// Extra Extra Extra Large: 48.0
  static const double xxxl = 6.0 * _base;

  // --- Widgets for common spacing ---

  /// SizedBox with height: [xs]
  static const Widget verticalSpaceXs = SizedBox(height: xs);

  /// SizedBox with height: [sm]
  static const Widget verticalSpaceSm = SizedBox(height: sm);

  /// SizedBox with height: [md]
  static const Widget verticalSpaceMd = SizedBox(height: md);

  /// SizedBox with height: [lg]
  static const Widget verticalSpaceLg = SizedBox(height: lg);

  /// SizedBox with height: [xl]
  static const Widget verticalSpaceXl = SizedBox(height: xl);

  /// SizedBox with height: [xxl]
  static const Widget verticalSpaceXxl = SizedBox(height: xxl);

  /// SizedBox with height: [xxxl]
  static const Widget verticalSpaceXxxl = SizedBox(height: xxxl);

  /// SizedBox with width: [xs]
  static const Widget horizontalSpaceXs = SizedBox(width: xs);

  /// SizedBox with width: [sm]
  static const Widget horizontalSpaceSm = SizedBox(width: sm);

  /// SizedBox with width: [md]
  static const Widget horizontalSpaceMd = SizedBox(width: md);

  /// SizedBox with width: [lg]
  static const Widget horizontalSpaceLg = SizedBox(width: lg);

  /// SizedBox with width: [xl]
  static const Widget horizontalSpaceXl = SizedBox(width: xl);

  /// SizedBox with width: [xxl]
  static const Widget horizontalSpaceXxl = SizedBox(width: xxl);

  /// SizedBox with width: [xxxl]
  static const Widget horizontalSpaceXxxl = SizedBox(width: xxxl);
}
