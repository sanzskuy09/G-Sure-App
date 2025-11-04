// Import package yang diperlukan
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Pastikan package 'intl' ada di pubspec.yaml

class FaceVerificationPage extends StatefulWidget {
  final Map<String, dynamic>? formAnswers;

  const FaceVerificationPage({
    Key? key,
    this.formAnswers,
  }) : super(key: key);

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  bool _isLoading = false;

  // Asumsi ini adalah warna tema Anda, sesuai dengan gambar
  final Color primaryColor =
      const Color(0xFFC62828); // Merah tua (seperti Pefindo)

  // --- (FungSI LOGIKA ANDA TETAP SAMA) ---
  Future<String> _captureAndVerifyFace(BuildContext context) async {
    // ... (SELURUH KODE _captureAndVerifyFace ANDA ADA DI SINI) ...
    // ... (Tidak ada perubahan pada logika 'try' 'catch' Anda) ...
    // ... (Pastikan kode Basic Auth dan format 'dob' Anda ada di sini) ...

    // --- CONTOH SINGKAT LOGIKA (JANGAN DISALIN JIKA SUDAH ADA) ---
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
      if (imageFile == null) return 'Batal';

      final List<int> imageBytes = await File(imageFile.path).readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Ambil data
      final String? nik = widget.formAnswers?['nik'];
      final String? nama = widget.formAnswers?['nama'];
      final String? email = widget.formAnswers?['email'];
      final String? nohp = widget.formAnswers?['nohp'];
      final String? tgllahir = widget.formAnswers?['tgllahir'];
      String? formattedDob;

      if (tgllahir != null && tgllahir.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(tgllahir);
          formattedDob = DateFormat('dd-MM-yyyy').format(parsedDate);
        } catch (e) {
          print('Error parsing tanggal: $e');
        }
      }

      final Map<String, dynamic> apiBody = {
        // "govid": nik,
        // "fullname": nama,
        // "dob": formattedDob,
        // "email": email,
        // "mobile": nohp,
        // "InquiryReason": "ProvidingFacilities",
        // "ReferenceCode": "testAbits111",
        // 'image_base64': base64Image
        // ====
        "govid": "3511000101806300",
        "fullname": "UserIAA",
        "dob": "13-05-1992",
        "email": "test@testing.com",
        "mobile": "+62818000222",
        "InquiryReason": "ProvidingFacilities",
        "ReferenceCode": "testAbits111",
        'image_base64': base64Image,
      };

      // Basic Auth
      final String username = 'gfi001';
      final String password = 'Pefindo123!!';
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      final Uri apiUrl = Uri.parse(
          'https://acsdemo.pefindobirokredit.com/api/v1.0/GetPreScreeningElecDukcapil');

      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
        body: jsonEncode(apiBody),
      );

      if (response.statusCode == 200) {
        return 'Diterima';
      } else {
        print('API Error: ${response.body}');
        return 'Ditolak';
      }
    } catch (e) {
      print('Terjadi error saat verifikasi: $e');
      return 'Ditolak';
    }
  }

  void _startVerificationProcess() async {
    setState(() {
      _isLoading = true;
    });

    final String result = await _captureAndVerifyFace(context);

    if (!mounted) return; // Cek jika widget masih ada

    setState(() {
      _isLoading = false;
    });

    if (result == 'Batal') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengambilan foto dibatalkan.')),
      );
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  // --- (BAGIAN UI YANG DIPERBARUI) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Wajah'),
        backgroundColor: primaryColor, // Samakan warna AppBar
        foregroundColor: Colors.white, // Teks putih di AppBar
      ),
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: Center(
        child: Padding(
          // Beri jarak dari tepi layar
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: _isLoading
              ? _buildLoadingUI() // Tampilan saat loading
              : _buildVerificationUI(), // Tampilan awal
        ),
      ),
    );
  }

  /// Tampilan UI untuk status awal (tombol verifikasi)
  Widget _buildVerificationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
      crossAxisAlignment: CrossAxisAlignment.stretch, // Rentangkan tombol
      children: [
        // 1. Ikon
        Icon(
          Icons.face_retouching_natural_outlined,
          size: 120.0,
          color: primaryColor, // Gunakan warna tema
        ),
        const SizedBox(height: 24.0),

        // 2. Judul
        Text(
          'Verifikasi Wajah',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16.0),

        // 3. Instruksi
        Text(
          'Kami perlu memverifikasi identitas Anda. Silakan ambil foto wajah Anda dengan jelas.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[600],
            height: 1.4, // Jarak antar baris
          ),
        ),
        const SizedBox(height: 48.0), // Jarak lebih besar sebelum tombol

        // 4. Tombol Aksi (CTA)
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt, size: 24),
          label: const Text('Mulai Ambil Foto'),
          onPressed: _startVerificationProcess,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, // Warna tombol
            foregroundColor: Colors.white, // Warna teks & ikon di tombol
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Tombol lebih bulat
            ),
            elevation: 4.0, // Sedikit bayangan
          ),
        ),
      ],
    );
  }

  /// Tampilan UI untuk status loading
  Widget _buildLoadingUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
        const SizedBox(height: 24.0),
        Text(
          'Memproses Verifikasi...\nMohon tunggu.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
