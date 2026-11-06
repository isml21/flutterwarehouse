import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A reusable, highly customizable Glassmorphism Container with BackdropFilter blur,
/// frosted surface reflection, specular border highlight, and soft diffusion shadow.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? color;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 16.0,
    this.opacity = 0.75,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(16.0);

    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (color ?? Colors.white).withValues(alpha: opacity),
            (color ?? Colors.white).withValues(alpha: (opacity * 0.6).clamp(0.0, 1.0)),
          ],
        );

    final effectiveBorder = border ??
        Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.2,
        );

    final effectiveBoxShadow = boxShadow ??
        [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.4),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ];

    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: effectiveBorderRadius,
        border: effectiveBorder,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius is BorderRadius
              ? effectiveBorderRadius
              : BorderRadius.circular(16),
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveBoxShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      ),
    );
  }
}

/// An atmospheric background with smooth ambient gradient orbs.
/// Essential for Glassmorphism so that frosted surfaces show real refraction and depth.
class AmbientBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const AmbientBackground({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base canvas color
        Container(
          color: isDark ? AppColors.backgroundDark : const Color(0xFFF3F6FB),
        ),

        // Glowing Ambient Orb 1 (Top Right - Soft Sky / Indigo)
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: size.width * 0.75,
            height: size.width * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.accent : const Color(0xFF93C5FD))
                      .withValues(alpha: isDark ? 0.35 : 0.45),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 2 (Middle Left - Soft Purple / Violet)
        Positioned(
          top: size.height * 0.35,
          left: -80,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.ambientPurple : const Color(0xFFC7D2FE))
                      .withValues(alpha: isDark ? 0.30 : 0.40),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 3 (Bottom Right - Warm Warehouse Amber)
        Positioned(
          bottom: -50,
          right: -40,
          child: Container(
            width: size.width * 0.65,
            height: size.width * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? AppColors.amber : const Color(0xFFFDE68A))
                      .withValues(alpha: isDark ? 0.25 : 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Content on top
        child,
      ],
    );
  }
}

