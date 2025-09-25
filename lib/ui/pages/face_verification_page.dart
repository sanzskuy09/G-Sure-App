import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:gsure/ui/pages/submission_form_page.dart';
import 'package:gsure/ui/widgets/face_frame_painter.dart'; // Ganti 'gsure' dengan nama project Anda
import 'package:gsure/ui/widgets/face_painter.dart';

class FaceVerificationPage extends StatefulWidget {
  const FaceVerificationPage({super.key});

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  late final FaceDetector _faceDetector;
  CustomPaint? _customPaint;
  String _instruction = "Posisikan wajah Anda di tengah";
  bool _isDetecting = false;
  bool _isProcessingSuccess = false;

  @override
  void initState() {
    super.initState();
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true, // WAJIB DIAKTIFKAN UNTUK MENDAPATKAN MESH
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });

    _cameraController!.startImageStream(_processImage);
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting || _isProcessingSuccess || !mounted) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        final double? leftEyeOpenProb = face.leftEyeOpenProbability;
        final double? rightEyeOpenProb = face.rightEyeOpenProbability;

        if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
          if (leftEyeOpenProb < 0.2 && rightEyeOpenProb < 0.2) {
            if (mounted) {
              setState(() => _instruction = "Verifikasi berhasil!");
              // PANGGIL FUNGSI BARU DI SINI
              _onVerificationSuccess();
            }
          } else {
            if (mounted)
              setState(() => _instruction = "Bagus! Sekarang silakan berkedip");
          }
        }

        final painter = FacePainter(
          face: face,
          imageSize: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          cameraLensDirection: _cameraController!.description.lensDirection,
        );
        if (mounted)
          setState(() => _customPaint = CustomPaint(painter: painter));
      } else {
        if (mounted) {
          setState(() {
            _customPaint = null;
            _instruction = "Posisikan wajah Anda di tengah";
          });
        }
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    } finally {
      if (mounted) _isDetecting = false;
    }
  }

  // Future<void> _onVerificationSuccess() async {
  //   if (_isProcessingSuccess) return;
  //   setState(() => _isProcessingSuccess = true);

  //   await _cameraController?.stopImageStream();

  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Verifikasi Wajah Berhasil!')),
  //   );

  //   final XFile imageFile = await _cameraController!.takePicture();
  //   final Uint8List imageBytes = await imageFile.readAsBytes();
  //   final String base64Image = base64Encode(imageBytes);

  //   // ===== PERUBAHAN UTAMA DI SINI =====
  //   // 1. Lepaskan controller kamera SEPENUHNYA
  //   await _cameraController?.dispose();

  //   // 2. Set state controller menjadi null agar CameraPreview tidak error
  //   setState(() {
  //     _cameraController = null;
  //   });
  //   // ===================================

  //   if (!mounted) return;

  //   // Navigasi ke halaman form baru setelah kamera benar-benar mati
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SubmissionFormPage(
  //         base64Image: base64Image,
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _onVerificationSuccess() async {
  //   // 1. Set flag agar fungsi ini tidak dipanggil berkali-kali
  //   if (_isProcessingSuccess) return;
  //   setState(() => _isProcessingSuccess = true);

  //   // 2. Hentikan stream kamera
  //   await _cameraController?.stopImageStream();

  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Verifikasi Wajah Berhasil!')),
  //   );

  //   // 3. Ambil gambar dengan kualitas terbaik
  //   final XFile imageFile = await _cameraController!.takePicture();
  //   final Uint8List imageBytes = await imageFile.readAsBytes();
  //   final String base64Image = base64Encode(imageBytes);

  //   if (!mounted) return;

  //   // 4. Navigasi ke halaman form baru dan kirim data gambar
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SubmissionFormPage(
  //         base64Image: base64Image,
  //       ),
  //     ),
  //   ).then((_) {
  //     // 2. BLOK INI AKAN DIJALANKAN SETELAH NAVIGASI SELESAI
  //     // Kita tambahkan jeda singkat untuk memastikan animasi transisi benar-benar selesai
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       // 3. Pastikan halaman masih ada (mounted) sebelum mencoba dispose
  //       if (mounted) {
  //         _cameraController?.dispose();
  //         setState(() {
  //           _cameraController = null;
  //           // Reset flag agar jika user kembali, verifikasi bisa dimulai lagi
  //           _isDetecting = false;
  //           _isProcessingSuccess = false;
  //         });
  //       }
  //     });
  //   });
  // }

  // Lokasi: di dalam _FaceVerificationPageState

  Future<void> _onVerificationSuccess() async {
    if (_isProcessingSuccess) return;
    setState(() => _isProcessingSuccess = true);

    // Hentikan stream agar tidak ada proses yang berjalan selama transisi
    await _cameraController?.stopImageStream();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verifikasi Wajah Berhasil!')),
    );

    // Ambil gambar dengan kualitas terbaik
    final XFile imageFile = await _cameraController!.takePicture();
    final Uint8List imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    if (!mounted) return;

    // ===== GANTI NAVIGASI DENGAN PUSHREPLACEMENT =====
    // Ini akan menghapus halaman kamera dan menggantinya dengan halaman form.
    // Method dispose() dari halaman ini akan otomatis dipanggil.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SubmissionFormPage(
          base64Image: base64Image,
        ),
      ),
    );
  }

  // Future<void> _captureAndGoBack() async {
  //   await _cameraController?.stopImageStream();
  //   if (!mounted) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Wajah berhasil diverifikasi!'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );

  //   await Future.delayed(const Duration(seconds: 1));
  //   if (mounted) Navigator.of(context).pop();
  // }

  // --- Gunakan fungsi _inputImageFromCameraImage dari jawaban sebelumnya ---
  // (Pastikan fungsi ini ada di sini)

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      var rotationCompensation = (sensorOrientation + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (image.planes.length == 1) {
      return InputImage.fromBytes(
          bytes: image.planes[0].bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotation,
            format: format!,
            bytesPerRow: image.planes[0].bytesPerRow,
          ));
    }

    final allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Face detection', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(), // Hapus tombol back default
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 48),

          // Area Kamera
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AspectRatio(
              aspectRatio: 3 / 4, // Rasio aspek untuk area kamera
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isCameraInitialized)
                      _buildCameraPreview()
                    else
                      const Center(child: CircularProgressIndicator()),

                    // Painter untuk bingkai statis
                    CustomPaint(painter: FaceFramePainter()),

                    // Painter untuk mesh wajah dinamis
                    if (_customPaint != null) _customPaint!,
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // Area Footer
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            decoration: const BoxDecoration(
              color: Colors.white,
              // Jika ingin ada bayangan
              // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
            ),
            child: Column(
              children: [
                Text(
                  _instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please keep your face centered on the screen and facing forward',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const LinearProgressIndicator(), // Contoh progress bar
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraController == null) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final cameraAspectRatio = _cameraController!.value.aspectRatio;
    var scale = size.aspectRatio * cameraAspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_cameraController!),
      ),
    );
  }
}
