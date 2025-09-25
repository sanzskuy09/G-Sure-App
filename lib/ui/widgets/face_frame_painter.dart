import 'package:flutter/material.dart';

class FaceFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cornerStrokeWidth = 4.0;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Gambar bingkai utama yang tipis
    final mainRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );
    canvas.drawRRect(mainRRect, paint);

    // Gambar penanda sudut (corner brackets) yang lebih tebal
    paint.strokeWidth = cornerStrokeWidth;
    paint.color = Colors.white;
    const cornerLength = 24.0;
    const offset = cornerStrokeWidth / 2;

    // Sudut Kiri Atas
    canvas.drawPath(
      Path()
        ..moveTo(offset, cornerLength)
        ..lineTo(offset, offset)
        ..lineTo(cornerLength, offset),
      paint,
    );

    // Sudut Kanan Atas
    canvas.drawPath(
      Path()
        ..moveTo(size.width - offset, cornerLength)
        ..lineTo(size.width - offset, offset)
        ..lineTo(size.width - cornerLength, offset),
      paint,
    );

    // Sudut Kiri Bawah
    canvas.drawPath(
      Path()
        ..moveTo(offset, size.height - cornerLength)
        ..lineTo(offset, size.height - offset)
        ..lineTo(cornerLength, size.height - offset),
      paint,
    );

    // Sudut Kanan Bawah
    canvas.drawPath(
      Path()
        ..moveTo(size.width - offset, size.height - cornerLength)
        ..lineTo(size.width - offset, size.height - offset)
        ..lineTo(size.width - cornerLength, size.height - offset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
