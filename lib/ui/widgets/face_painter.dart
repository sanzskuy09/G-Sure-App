import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:ui' as ui;

class FacePainter extends CustomPainter {
  final Face face;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;

  FacePainter({
    required this.face,
    required this.imageSize,
    this.cameraLensDirection = CameraLensDirection.front,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ---- LOGIKA TRANSFORMASI KOORDINAT (TETAP SAMA) ----
    // Ini penting agar posisi mesh sesuai dengan preview di layar
    final double scaleX = size.width / imageSize.height;
    final double scaleY = size.height / imageSize.width;

    // Fungsi untuk mentransformasi setiap titik dari gambar ke layar
    Offset transformPoint(Offset point, bool mirror) {
      double x = point.dx;
      if (mirror) {
        x = imageSize.width - x;
      }
      return Offset(x * scaleX, point.dy * scaleY);
    }

    final bool isMirrored = cameraLensDirection == CameraLensDirection.front;

    // ---- LOGIKA MENGGAMBAR MESH (BARU) ----
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final pointPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5;

    // Iterasi melalui semua jenis kontur yang terdeteksi
    for (final FaceContourType type in face.contours.keys) {
      final FaceContour? contour = face.contours[type];
      if (contour != null && contour.points.isNotEmpty) {
        // Ambil semua titik dari kontur
        final List<Offset> points = contour.points
            .map((p) => transformPoint(
                Offset(p.x.toDouble(), p.y.toDouble()), isMirrored))
            .toList();

        // Gambar titik-titik (vertices)
        canvas.drawPoints(ui.PointMode.points, points, pointPaint);

        // Gambar garis yang menghubungkan titik-titik
        // Kita gunakan drawPath agar garis tidak menyambung dari akhir ke awal
        final path = Path();
        path.moveTo(points.first.dx, points.first.dy);
        for (var i = 1; i < points.length; i++) {
          path.lineTo(points[i].dx, points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.face != face || oldDelegate.imageSize != imageSize;
  }
}
