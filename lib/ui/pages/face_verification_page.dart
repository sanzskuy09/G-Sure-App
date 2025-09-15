import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:gsure/ui/widgets/face_painter.dart';

class FaceVerificationPage extends StatefulWidget {
  const FaceVerificationPage({super.key});

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  // Controller untuk kamera
  CameraController? _cameraController;
  // Flag untuk menandakan apakah kamera sudah siap
  bool _isCameraInitialized = false;
  // Instance dari FaceDetector
  late final FaceDetector _faceDetector;
  // Untuk menggambar kotak di wajah
  CustomPaint? _customPaint;
  // Status instruksi untuk pengguna
  String _instruction = "Posisikan wajah Anda di dalam bingkai";
  // Flag untuk mencegah deteksi berulang
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi FaceDetector dengan opsi untuk mendeteksi landmark dan klasifikasi (kedipan)
    final options = FaceDetectorOptions(
      enableClassification: true, // Untuk deteksi kedipan & senyuman
      enableLandmarks: true, // Untuk mendeteksi bentuk wajah
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);

    // Mulai inisialisasi kamera
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // Fungsi untuk inisialisasi kamera
  Future<void> _initializeCamera() async {
    // Dapatkan daftar kamera yang tersedia
    final cameras = await availableCameras();
    // Pilih kamera depan
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

    // Mulai streaming gambar dari kamera untuk diproses
    _cameraController!.startImageStream(_processImage);
  }

  // Fungsi untuk memproses setiap frame gambar dari kamera
  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      // Proses gambar untuk mendeteksi wajah
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first; // Ambil wajah pertama yang terdeteksi

        // Cek liveness sederhana: Kedipan mata
        // Nilai probabilitas mata terbuka: 1.0 (sangat yakin terbuka), 0.0 (sangat yakin tertutup)
        final double? leftEyeOpenProb = face.leftEyeOpenProbability;
        final double? rightEyeOpenProb = face.rightEyeOpenProbability;

        if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
          if (leftEyeOpenProb < 0.2 && rightEyeOpenProb < 0.2) {
            // Mata terdeteksi berkedip!
            setState(() {
              _instruction = "Verifikasi berhasil!";
            });
            _captureAndGoBack();
          } else {
            setState(() {
              _instruction = "Bagus! Sekarang silakan berkedip";
            });
          }
        } else {
          setState(() {
            _instruction = "Posisikan wajah Anda di dalam bingkai";
          });
        }

        // Buat painter untuk menggambar kotak di wajah
        final painter = FacePainter(
          face: face,
          imageSize: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          cameraLensDirection: _cameraController!.description.lensDirection,
        );
        setState(() {
          _customPaint = CustomPaint(painter: painter);
        });
      } else {
        // Jika tidak ada wajah terdeteksi
        setState(() {
          _customPaint = null;
          _instruction = "Posisikan wajah Anda di dalam bingkai";
        });
      }
    } catch (e) {
      debugPrint("Error processing image: $e");
    } finally {
      _isDetecting = false;
    }
  }

  // Fungsi untuk mengambil foto dan kembali ke halaman sebelumnya
  Future<void> _captureAndGoBack() async {
    // Hentikan deteksi agar tidak berjalan terus menerus
    if (!_isDetecting) return;
    _isDetecting = false; // Mencegah pemanggilan ganda

    await _cameraController?.stopImageStream();

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wajah berhasil diverifikasi!'),
        backgroundColor: Colors.green,
      ),
    );

    // Tunggu sejenak lalu kembali
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // Helper untuk konversi format gambar
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;

    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    return InputImage.fromBytes(
      bytes: image.planes.first.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Tampilkan preview kamera jika sudah siap
          if (_isCameraInitialized)
            CameraPreview(_cameraController!)
          else
            const Center(child: CircularProgressIndicator()),

          // Tampilkan kotak di sekitar wajah
          if (_customPaint != null) _customPaint!,

          // UI Tambahan (Instruksi & Tombol Kembali)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  _instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
