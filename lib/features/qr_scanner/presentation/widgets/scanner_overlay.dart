import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ScannerOverlay extends StatefulWidget {
  final Rect scanWindow;

  const ScannerOverlay({
    super.key,
    required this.scanWindow,
  });

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ScannerOverlayPainter(
            scanWindow: widget.scanWindow,
            animationValue: _animationController.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double animationValue;

  _ScannerOverlayPainter({
    required this.scanWindow,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Dark background with cutout for scan window
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final windowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      );

    final overlayPath =
        Path.combine(PathOperation.difference, backgroundPath, windowPath);
    canvas.drawPath(overlayPath, backgroundPaint);

    // Border surrounding the window
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)),
      borderPaint,
    );

    // Corner guides
    final cornerPaint = Paint()
      ..color = AppColors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    const cornerLength = 26.0;
    final r = scanWindow;

    // Top-left
    canvas.drawLine(
        Offset(r.left, r.top + cornerLength), Offset(r.left, r.top + 10), cornerPaint);
    canvas.drawLine(
        Offset(r.left + 10, r.top), Offset(r.left + cornerLength, r.top), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(r.right - cornerLength, r.top),
        Offset(r.right - 10, r.top), cornerPaint);
    canvas.drawLine(Offset(r.right, r.top + 10),
        Offset(r.right, r.top + cornerLength), cornerPaint);

    // Bottom-left
    canvas.drawLine(Offset(r.left, r.bottom - cornerLength),
        Offset(r.left, r.bottom - 10), cornerPaint);
    canvas.drawLine(Offset(r.left + 10, r.bottom),
        Offset(r.left + cornerLength, r.bottom), cornerPaint);

    // Bottom-right
    canvas.drawLine(Offset(r.right - cornerLength, r.bottom),
        Offset(r.right - 10, r.bottom), cornerPaint);
    canvas.drawLine(Offset(r.right, r.bottom - 10),
        Offset(r.right, r.bottom - cornerLength), cornerPaint);

    // Animated scanning laser line
    final laserY = scanWindow.top + (scanWindow.height * animationValue);
    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.amber.withValues(alpha: 0.0),
          AppColors.amber,
          AppColors.amber.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromLTWH(scanWindow.left, laserY, scanWindow.width, 3),
      )
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(scanWindow.left + 10, laserY),
      Offset(scanWindow.right - 10, laserY),
      laserPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.scanWindow != scanWindow;
  }
}
