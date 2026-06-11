import 'package:flutter/material.dart';

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    // Red Arc
    paint.color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.15, h * 0.15)
      ..arcTo(Rect.fromLTWH(0, 0, w, h), -2.356, 1.57, false)
      ..lineTo(w * 0.5, h * 0.5);
    canvas.drawPath(redPath, paint);

    // Yellow Arc
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.15, h * 0.85)
      ..arcTo(Rect.fromLTWH(0, 0, w, h), -3.927, 1.57, false)
      ..lineTo(w * 0.5, h * 0.5);
    canvas.drawPath(yellowPath, paint);

    // Green Arc
    paint.color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.85, h * 0.85)
      ..arcTo(Rect.fromLTWH(0, 0, w, h), 0.785, 1.57, false)
      ..lineTo(w * 0.5, h * 0.5);
    canvas.drawPath(greenPath, paint);

    // Blue Arc & Crossbar
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.85, h * 0.15)
      ..arcTo(Rect.fromLTWH(0, 0, w, h), -0.785, 1.57, false)
      ..lineTo(w * 0.5, h * 0.5);
    canvas.drawPath(bluePath, paint);

    final crossBar = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.95, h * 0.5)
      ..lineTo(w * 0.95, h * 0.65)
      ..lineTo(w * 0.5, h * 0.65)
      ..close();
    canvas.drawPath(crossBar, paint);

    paint.color = Colors.white;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.3, paint);

    paint.color = const Color(0xFF4285F4);
    final crossFix = Path()
      ..moveTo(w * 0.5, h * 0.45)
      ..lineTo(w * 0.75, h * 0.45)
      ..lineTo(w * 0.75, h * 0.55)
      ..lineTo(w * 0.5, h * 0.55)
      ..close();
    canvas.drawPath(crossFix, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}