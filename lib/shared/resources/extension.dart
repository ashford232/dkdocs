import 'package:flutter/material.dart';

abstract final class Breakpoints {
  static const double xs = 360;
  static const double sm = 500;

  static const double md = 840;

  static const double lg = 1024;

  static const double xl = 1440;

  static const double xxl = 1920;

  static const double maxContentWidth = 1440;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isXs => screenWidth < Breakpoints.sm;

  bool get isSm =>
      screenWidth >= Breakpoints.sm && screenWidth < Breakpoints.md;

  bool get isMd =>
      screenWidth >= Breakpoints.md && screenWidth < Breakpoints.lg;

  bool get isLg =>
      screenWidth >= Breakpoints.lg && screenWidth < Breakpoints.xl;

  bool get isXl =>
      screenWidth >= Breakpoints.xl && screenWidth < Breakpoints.xxl;

  bool get isXxl => screenWidth >= Breakpoints.xxl;

  T value<T>({required T xs, T? sm, T? md, T? lg, T? xl, T? xxl}) {
    if (isXxl) return xxl ?? xl ?? lg ?? md ?? sm ?? xs;
    if (isXl) return xl ?? lg ?? md ?? sm ?? xs;
    if (isLg) return lg ?? md ?? sm ?? xs;
    if (isMd) return md ?? sm ?? xs;
    if (isSm) return sm ?? xs;
    return xs;
  }

  EdgeInsets get responsivePadding => value(
    xs: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    sm: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    md: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    lg: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
    xl: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
    xxl: const EdgeInsets.symmetric(horizontal: 96, vertical: 40),
  );

  int get gridColumns => value(xs: 2, sm: 2, md: 3, lg: 3, xl: 3, xxl: 3);

  double get gridAspectRatio =>
      value(xs: 1, sm: 1.3, md: 0.8, lg: 0.75, xl: 0.7, xxl: 1.0);
}

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;

  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.value(
              xs: 360,
              sm: 500,
              md: 650,
              lg: 800,
              xl: 950,
              xxl: 1100,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AdaptiveConstraintBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    bool isWide,
  )
  builder;

  const AdaptiveConstraintBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= Breakpoints.sm;
        return builder(context, constraints, isWide);
      },
    );
  }
}
