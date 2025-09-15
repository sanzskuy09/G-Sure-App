import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.tealAccent;

    // Fungsi untuk mentransformasi koordinat dari gambar ke layar
    double scaleX = size.width / imageSize.height;
    double scaleY = size.height / imageSize.width;

    // Cerminkan koordinat X jika menggunakan kamera depan
    double left = face.boundingBox.left.toDouble();
    if (cameraLensDirection == CameraLensDirection.front) {
      left = imageSize.width - face.boundingBox.right.toDouble();
    }

    // Gambar kotak di sekeliling wajah
    canvas.drawRect(
      Rect.fromLTRB(
        left * scaleX,
        face.boundingBox.top.toDouble() * scaleY,
        (left + face.boundingBox.width.toDouble()) * scaleX,
        (face.boundingBox.top.toDouble() + face.boundingBox.height.toDouble()) *
            scaleY,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.face != face || oldDelegate.imageSize != imageSize;
  }
}
