import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupRestoreService {
  // PASTIKAN NAMA BOX DAN TIPE DATA SESUAI DENGAN YANG DIBUKA DI main.dart
  final String boxName = 'survey_apps';

  /// Meminta izin untuk mengelola penyimpanan eksternal.
  /// Mengarahkan pengguna ke pengaturan jika izin ditolak secara permanen.
  Future<bool> _requestPermission() async {
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Jika pengguna menolak secara permanen, arahkan ke pengaturan aplikasi
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  /// Membuat cadangan (backup) database Hive ke folder Download.
  Future<bool> backup(BuildContext context) async {
    try {
      if (!await _requestPermission()) {
        print("Izin tidak diberikan.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin akses penyimpanan ditolak.')),
        );
        return false;
      }

      // Langsung akses box yang sudah terbuka (tidak perlu openBox lagi)
      // Ganti <AplikasiSurvey> dengan tipe data Anda yang sebenarnya, misal <SurveyData>
      final box = Hive.box<AplikasiSurvey>(boxName);
      final boxPath = box.path;

      if (boxPath == null) {
        print('Path box Hive tidak ditemukan');
        return false;
      }

      // Mendapatkan direktori penyimpanan eksternal dan menargetkan folder Download
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Direktori penyimpanan eksternal tidak ditemukan');
        return false;
      }
      final String downloadPath = '${directory.path}/Download';

      final Directory downloadFolder = Directory(downloadPath);
      if (!await downloadFolder.exists()) {
        await downloadFolder.create(recursive: true);
      }

      // Membuat nama file yang unik dengan timestamp
      final String timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final String backupFileName = '$boxName-backup-$timestamp.hive';
      final String backupFilePath = '$downloadPath/$backupFileName';

      // Menyalin file dari path Hive ke folder Download
      await File(boxPath).copy(backupFilePath);

      print('Backup berhasil disimpan di: $backupFilePath');
      return true;
    } catch (e) {
      print('Error saat backup: $e');
      return false;
    }
  }

  /// Memulihkan (restore) database Hive dari file cadangan.
  Future<bool> restore(BuildContext context) async {
    try {
      // 1. Meminta pengguna memilih file (tanpa filter ekstensi)
      final result = await FilePicker.platform.pickFiles();

      if (result == null || result.files.single.path == null) {
        print("Tidak ada file yang dipilih");
        return false; // Pengguna membatalkan picker
      }

      // 2. Validasi manual untuk memastikan file yang dipilih adalah file .hive
      final String filePath = result.files.single.path!;
      if (!filePath.endsWith('.hive')) {
        print("File yang dipilih bukan file backup .hive");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('File tidak valid. Harap pilih file .hive')),
        );
        return false;
      }

      final backupFile = File(filePath);

      // 3. Dapatkan path tujuan (lokasi box Hive saat ini)
      // Ganti <AplikasiSurvey> dengan tipe data Anda yang sebenarnya
      final box = Hive.box<AplikasiSurvey>(boxName);
      final boxPath = box.path;
      if (boxPath == null) {
        print("Path box Hive tidak ditemukan");
        return false;
      }

      // 4. PENTING: Tutup box sebelum menimpanya
      await box.close();

      // 5. Salin file backup ke lokasi file Hive
      await backupFile.copy(boxPath);

      // 6. Buka kembali box agar data baru bisa dibaca
      // Ganti <AplikasiSurvey> dengan tipe data Anda yang sebenarnya
      await Hive.openBox<AplikasiSurvey>(boxName);

      print('Restore berhasil dari: ${backupFile.path}');
      return true;
    } catch (e) {
      print('Error saat restore: $e');
      // Jika terjadi error, coba buka kembali box agar aplikasi tidak crash
      if (!Hive.isBoxOpen(boxName)) {
        // Ganti <AplikasiSurvey> dengan tipe data Anda yang sebenarnya
        await Hive.openBox<AplikasiSurvey>(boxName);
      }
      return false;
    }
  }
}

class BackupRestoreService1 {
  final String boxName = 'survey_apps';
  final String backupFilePrefix = 'surveys-backup-';

  Future<bool> _requestPermission() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) await openAppSettings();
    return false;
  }

  /// 🔽 FUNGSI BARU: Untuk mencari file backup terbaru secara otomatis 🔽
  Future<File?> _findLatestBackup() async {
    try {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final String downloadPath = '${directory.path}/Download';
      final downloadDir = Directory(downloadPath);

      // Pastikan folder Download ada
      if (!await downloadDir.exists()) {
        print("Folder Download tidak ditemukan.");
        return null;
      }

      // 1. Ambil semua file dari direktori Download
      final List<FileSystemEntity> entities = downloadDir.listSync();
      final List<File> backupFiles = [];

      // 2. Filter hanya file yang cocok dengan pola nama backup kita
      for (var entity in entities) {
        if (entity is File &&
            entity.path.split('/').last.startsWith(backupFilePrefix) &&
            entity.path.endsWith('.hive')) {
          backupFiles.add(entity);
        }
      }

      // 3. Jika tidak ada file backup, kembalikan null
      if (backupFiles.isEmpty) {
        print("Tidak ada file backup yang ditemukan.");
        return null;
      }

      // 4. Urutkan file berdasarkan nama (karena nama mengandung timestamp) dari yang terbaru ke terlama
      backupFiles.sort((a, b) => b.path.compareTo(a.path));

      // 5. Kembalikan file yang paling baru (elemen pertama setelah diurutkan)
      print("File backup terbaru ditemukan: ${backupFiles.first.path}");
      return backupFiles.first;
    } catch (e) {
      print("Error saat mencari backup: $e");
      return null;
    }
  }

  /// Fungsi backup (tidak ada perubahan, tetap sama)
  Future<bool> backup(BuildContext context) async {
    // ... (Kode fungsi backup Anda tetap sama persis seperti sebelumnya) ...
    try {
      if (!await _requestPermission()) {
        print("Izin tidak diberikan.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin akses penyimpanan ditolak.')),
        );
        return false;
      }
      final box = Hive.box<AplikasiSurvey>(boxName);
      final boxPath = box.path;
      if (boxPath == null) {
        print('Path box Hive tidak ditemukan');
        return false;
      }
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Direktori penyimpanan eksternal tidak ditemukan');
        return false;
      }
      final String downloadPath = '${directory.path}/Download';
      final Directory downloadFolder = Directory(downloadPath);
      if (!await downloadFolder.exists()) {
        await downloadFolder.create(recursive: true);
      }
      final String timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final String backupFileName = '$backupFilePrefix$timestamp.hive';
      final String backupFilePath = '$downloadPath/$backupFileName';
      await File(boxPath).copy(backupFilePath);
      print('Backup berhasil disimpan di: $backupFilePath');
      return true;
    } catch (e) {
      print('Error saat backup: $e');
      return false;
    }
  }

  /// 🔽 FUNGSI RESTORE YANG DIMODIFIKASI: Tidak lagi menggunakan FilePicker 🔽
  Future<bool> restore(BuildContext context) async {
    try {
      // 1. Minta izin terlebih dahulu
      if (!await _requestPermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin akses penyimpanan ditolak.')),
        );
        return false;
      }

      // 2. Cari file backup terbaru secara otomatis
      final File? backupFile = await _findLatestBackup();

      // 3. Jika tidak ada file backup yang ditemukan, beri tahu pengguna
      if (backupFile == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File backup tidak ditemukan.')),
          );
        }
        return false;
      }

      // ---- Proses restore selanjutnya sama persis ----

      final box = Hive.box<AplikasiSurvey>(boxName);
      final boxPath = box.path;
      if (boxPath == null) return false;

      await box.close();
      await backupFile.copy(boxPath);
      await Hive.openBox<AplikasiSurvey>(boxName);

      print('Restore berhasil dari: ${backupFile.path}');
      return true;
    } catch (e) {
      print('Error saat restore: $e');
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<AplikasiSurvey>(boxName);
      }
      return false;
    }
  }
}
