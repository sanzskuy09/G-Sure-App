import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// Ganti 'gsure' dengan nama project Anda jika diperlukan
import 'package:gsure/ui/pages/home_page.dart';
import 'package:http/http.dart' as http;

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
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

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
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // void _submitForm() {
  //   // Validasi form
  //   if (_formKey.currentState!.validate()) {
  //     final data = {
  //       'fullname': _nameController.text,
  //       'govid': _nikController.text,
  //       'selfiePhoto': widget.base64Image,
  //       'dob': _dobController.text,
  //       'email': _emailController.text,
  //       'phone': _phoneController.text,
  //       'InquiryReason': "ProvidingFacilities",
  //       'ReferenceCode': "testAbits111",
  //     };

  //     // Tampilkan data di console (di sini Anda akan mengirim data ke API)
  //     print('--- DATA FINAL SIAP DIKIRIM ---');
  //     print(data);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Data pengajuan berhasil dikirim!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     // Navigasi ke halaman utama dan hapus semua halaman sebelumnya dari stack
  //     // Navigator.of(context).pushAndRemoveUntil(
  //     //   MaterialPageRoute(builder: (context) => const HomePage()),
  //     //   (Route<dynamic> route) => false,
  //     // );
  //     // Navigator.pushNamedAndRemoveUntil(context, '/list-survey', (_) => false);
  //     Navigator.pop(context);
  //   }
  // }

  void _submitForm() async {
    // 1. Validasi form
    if (_formKey.currentState!.validate()) {
      // Tampilkan loading indicator dan nonaktifkan tombol
      setState(() {
        _isLoading = true;
      });

      // 2. Siapkan data dan URL
      final url = Uri.parse(
          'https://acsdemo.pefindobirokredit.com/api/v1.0/GetPreScreeningElecDukcapil');
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        // Jika ada otentikasi (API Key/Bearer Token), tambahkan di sini
        // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
      };
      final data = {
        'fullname': _nameController.text,
        'govid': _nikController.text,
        'selfiePhoto': widget.base64Image,
        // API mungkin mengharapkan format tanggal YYYY-MM-DD
        // Lakukan konversi jika perlu, contoh:
        // 'dob': DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(_dobController.text)),
        'dob': DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(
            _dobController.text)), // Sesuaikan format jika diperlukan API
        'email': _emailController.text,
        'phone': _phoneController.text,
        'InquiryReason': "ProvidingFacilities",
        'ReferenceCode': "testAbits111", // Pastikan ini unik jika diperlukan
      };

      // Encode data map ke dalam format JSON string
      final body = jsonEncode(data);

      try {
        // 3. Kirim request POST
        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );

        // 4. Tangani response dari server
        if (response.statusCode == 200) {
          // SUKSES
          print('--- RESPONSE SUKSES ---');
          print(response.body);

          final responseData = jsonDecode(response.body);
          // Lakukan sesuatu dengan responseData jika perlu

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data pengajuan berhasil dikirim!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigasi setelah sukses
          if (mounted) Navigator.pop(context);
        } else {
          // GAGAL (Error dari server)
          print('--- RESPONSE GAGAL ---');
          print('Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Gagal mengirim data. Error: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // GAGAL (Error koneksi atau lainnya)
        print('--- TERJADI ERROR ---');
        print(e.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan koneksi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Sembunyikan loading indicator setelah selesai
        setState(() {
          _isLoading = false;
        });
      }
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

                const SizedBox(height: 24),

                TextFormField(
                  controller:
                      _dobController, // Anda perlu membuat controller ini
                  readOnly: true, // Mencegah keyboard muncul
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Lahir',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Pilih tanggal',
                  ),
                  onTap: () async {
                    // Menampilkan date picker ketika field diklik
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      // Format tanggal dan set ke controller
                      // Anda perlu package 'intl' untuk ini: pub.dev/packages/intl
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      _dobController.text = formattedDate;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal Lahir tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // --- TextFormField Email ---
                TextFormField(
                  controller:
                      _emailController, // Anda perlu membuat controller ini
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    // Validasi format email sederhana menggunakan Regex
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // --- TextFormField No. Handphone ---
                TextFormField(
                  controller:
                      _phoneController, // Anda perlu membuat controller ini
                  decoration: const InputDecoration(
                    labelText: 'No. Handphone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  // Memastikan hanya angka yang bisa diinput
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No. Handphone tidak boleh kosong';
                    }
                    if (value.length < 10 || value.length > 13) {
                      return 'No. Handphone tidak valid (10-13 digit)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // ElevatedButton(
                //   onPressed: _submitForm,
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(vertical: 16),
                //     textStyle: const TextStyle(
                //         fontSize: 18, fontWeight: FontWeight.bold),
                //   ),
                //   child: const Text('Kirim Pengajuan'),
                // ),
                ElevatedButton(
                  // Nonaktifkan tombol saat loading untuk mencegah klik ganda
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text('Kirim Pengajuan'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
