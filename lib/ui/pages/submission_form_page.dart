import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// Ganti 'gsure' dengan nama project Anda jika diperlukan
import 'package:gsure/ui/pages/home_page.dart';

class SubmissionFormPage extends StatefulWidget {
  final String base64Image;

  const SubmissionFormPage({
    super.key,
    required this.base64Image,
  });

  @override
  State<SubmissionFormPage> createState() => _SubmissionFormPageState();
}

class _SubmissionFormPageState extends State<SubmissionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  late final Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    // Konversi string base64 kembali ke bytes untuk ditampilkan sebagai gambar
    _imageBytes = base64Decode(widget.base64Image);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _nameController.text,
        'nik': _nikController.text,
        'foto_wajah_base64': widget.base64Image,
      };

      // Tampilkan data di console (di sini Anda akan mengirim data ke API)
      print('--- DATA FINAL SIAP DIKIRIM ---');
      print(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data pengajuan berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi ke halaman utama dan hapus semua halaman sebelumnya dari stack
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => const HomePage()),
      //   (Route<dynamic> route) => false,
      // );
      // Navigator.pushNamedAndRemoveUntil(context, '/list-survey', (_) => false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Halaman ini menggunakan Scaffold standar yang akan menangani keyboard dengan benar
    return Scaffold(
      // resizeToAvoidBottomInset: true (ini adalah default dan yang kita inginkan)
      appBar: AppBar(
        title: const Text('Lengkapi Data Diri'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Foto Wajah Terverifikasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      _imageBytes,
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap (sesuai KTP)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nikController,
                  decoration: const InputDecoration(
                    labelText: 'NIK',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK tidak boleh kosong';
                    }
                    if (value.length != 16) {
                      return 'NIK harus terdiri dari 16 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Kirim Pengajuan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
