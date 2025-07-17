import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gsure/models/photo_data_model.dart'; // Ganti dengan path model Anda
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ContohDraftDetailPage extends StatefulWidget {
  final dynamic surveyKey;

  const ContohDraftDetailPage({super.key, required this.surveyKey});

  @override
  State<ContohDraftDetailPage> createState() => _ContohDraftDetailPageState();
}

class _ContohDraftDetailPageState extends State<ContohDraftDetailPage> {
  AplikasiSurvey? _surveyData;

  @override
  void initState() {
    super.initState();
    // Ambil data dari Hive berdasarkan key saat halaman pertama kali dibuka
    _loadSurveyData();
  }

  void _loadSurveyData() {
    final box = Hive.box<AplikasiSurvey>('survey_apps');
    final data = box.get(widget.surveyKey);

    // ✅ TAMBAHKAN BLOK INI UNTUK MELIHAT ISI DATA
    if (data != null) {
      // Ubah objek menjadi Map menggunakan method toJson()
      final dataMap = data.toJson();

      // Gunakan JsonEncoder untuk format yang rapi
      const encoder =
          JsonEncoder.withIndent('  '); // '  ' untuk 2 spasi indentasi
      final prettyprint = encoder.convert(dataMap);

      print("--- ISI DETAIL SURVEY DATA ---");
      print(prettyprint);
      print("----------------------------");
    }
    // ===============================================

    setState(() {
      _surveyData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL DRAFT SURVEY'),
      ),
      body: _surveyData == null
          // Tampilkan loading atau pesan error jika data tidak ditemukan
          ? const Center(
              child: Text('Data tidak ditemukan atau sedang dimuat...'),
            )
          // Tampilkan detail jika data ada
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionHeader('Data Pemohon'),
                _buildInfoRow('Nama', _surveyData!.dataPemohon?.nama),
                _buildInfoRow('NIK', _surveyData!.nik),
                _buildInfoRow('Status Pernikahan',
                    _surveyData!.dataPemohon?.statuspernikahan),
                // Tambahkan info lain dari dataPemohon jika perlu...

                const SizedBox(height: 24),

                // Menampilkan list foto pekerjaan
                _buildPhotoListSection(
                    'Foto & Dokumen Pekerjaan', _surveyData!.fotoPekerjaan!),

                // Menampilkan list foto simulasi
                _buildPhotoListSection(
                    'Foto & Dokumen Simulasi', _surveyData!.fotoSimulasi!),

                // Menampilkan list foto tambahan
                _buildPhotoListSection(
                    'Foto & Dokumen Tambahan', _surveyData!.fotoTambahan!),

                // Anda bisa menambahkan section lain di sini
                // Contoh:
                // const SizedBox(height: 24),
                // _buildSectionHeader('Data Kendaraan'),
                // _buildInfoRow('Merk', _surveyData!.dataKendaraan?.merkkendaraan),
              ],
            ),
    );
  }

  // --- WIDGET BANTUAN UNTUK TAMPILAN YANG LEBIH RAPI ---

  // Helper untuk membuat judul section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  // Helper untuk menampilkan baris info (label dan value)
  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Atur lebar label agar rapi
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value ?? '-', // Tampilkan '-' jika data null
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ HELPER KUNCI UNTUK MENAMPILKAN LIST FOTO
  Widget _buildPhotoListSection(String title, List<PhotoData> photos) {
    if (photos.isEmpty) {
      // Jangan tampilkan apapun jika list fotonya kosong
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildSectionHeader(title),
        // Gunakan .map untuk melakukan iterasi pada setiap item di list foto
        ...photos.map((photo) => _buildPhotoItem(photo)).toList(),
      ],
    );
  }

  // Helper untuk menampilkan satu item foto
  Widget _buildPhotoItem(PhotoData photo) {
    final path = photo.path;
    if (path == null || path.isEmpty) return const SizedBox.shrink();

    final file = File(path);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(child: Text('Gagal memuat gambar')),
                  );
                },
              ),
            ),
            if (photo.timestamp != null) ...[
              const SizedBox(height: 8),
              Text(
                'Waktu: ${DateFormat('dd MMM yyyy – HH:mm').format(photo.timestamp!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
