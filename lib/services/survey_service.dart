import 'dart:convert';

import 'package:gsure/models/order_model.dart';
import 'package:gsure/shared/shared_value.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SurveyService {
  // Future<List<OrderModel>> getDataListOrder() async {
  //   try {
  //     final res = await http.get(Uri.parse('$baseUrl/pemohon'));

  //     if (res.statusCode == 200) {
  //       final List<dynamic> body = jsonDecode(res.body);

  //       return body
  //           .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<List<OrderModel>> getDataListOrder(String username) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon/$username'));

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);

        return body
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendSurveyData(Map<String, dynamic> data) async {
    // Ganti 'submit-survey' dengan endpoint API Anda yang sebenarnya
    final Uri url = Uri.parse('$baseUrlSurvey/alldata');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // 200 (OK) atau 201 (Created) biasanya menandakan sukses
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data survey berhasil dikirim!');
        // Anda bisa mengembalikan response body jika diperlukan
        // return jsonDecode(response.body);
      } else {
        // Gagal mengirim data
        throw Exception(
            'Gagal mengirim data. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Menangani error koneksi atau lainnya
      print('Terjadi error saat mengirim data survey non file: $e');
      rethrow;
    }
  }

  Future<void> fileUploadService(Map<String, dynamic> data) async {
    final Uri url =
        Uri.parse('$baseUrlSurvey/api/foto-dokumen/upload/multiple');

    try {
      print('ini data $data');
      // final response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(data),
      // );

      // // 200 (OK) atau 201 (Created) biasanya menandakan sukses
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print('Data survey berhasil dikirim!');
      // } else {
      //   throw Exception(
      //       'Gagal mengirim data. Status: ${response.statusCode}, Body: ${response.body}');
      // }
    } catch (e) {
      print('Terjadi error saat mengirim foto survey: $e');
      rethrow;
    }
  }

  Future<void> uploadSurveyFiles({
    // Menerima Map berisi {'fotounitdepan': '/path/to/file.jpg'}
    required Map<String, String> filesToUpload,
    // Menerima data teks lainnya
    required Map<String, dynamic> textData,
  }) async {
    try {
      print('filesToUpload $filesToUpload');

      // Ganti 'POST' dan endpoint sesuai kebutuhan API Anda
      var uri = Uri.parse('$baseUrlSurvey/foto-dokumen/upload/multiple');
      var request = http.MultipartRequest('POST', uri);

      // --- 1. Tambahkan semua data teks ---
      textData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // --- 2. Tambahkan semua file yang akan di-upload ---
      // Looping pada 'daftar belanjaan' file yang sudah kita siapkan
      for (var entry in filesToUpload.entries) {
        final fieldName = entry.key; // misal: 'fotounitdepan'
        final filePath =
            entry.value; // misal: '/data/user/0/.../fotounitdepan_123.jpg'

        // INI BAGIAN KUNCINYA:
        // Membuat objek MultipartFile dari path file di perangkat.
        // http akan membaca file ini dan melampirkannya ke request.
        var multipartFile =
            await http.MultipartFile.fromPath(fieldName, filePath);

        // Tambahkan file ke request
        request.files.add(multipartFile);
      }

      // ✅ TAMBAHKAN BLOK DEBUGGING INI
      // =================================================================
      print("===================================");
      print("🔍 DETAIL REQUEST SEBELUM DIKIRIM");
      print("===================================");
      print("URL: ${request.method} ${request.url}");
      print("Headers: ${request.headers}");

      print("\n--- Fields (Data Teks) ---");
      request.fields.forEach((key, value) {
        print("  $key: $value");
      });

      print("\n--- Files (Data Gambar/File) ---");
      for (var file in request.files) {
        print("  Field Name: ${file.field}");
        print("    Filename: ${file.filename}");
        print("    Length: ${file.length} bytes");
        print("    Content-Type: ${file.contentType}");
      }
      print("===================================");
      // =================================================================

      // --- 3. Kirim request ---
      print('Mengirim ${request.files.length} file ke server...');
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ File-file berhasil di-upload!');
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Gagal upload file: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      print('❌ Error saat upload file: $e');
      rethrow;
    }
  }

  Future<void> uploadTambahanSurveyFiles({
    // Menerima Map file yang sudah dikelompokkan
    required Map<String, List<String>> filesToUpload,
    // Menerima Map data teks
    required Map<String, dynamic> textData,
  }) async {
    try {
      var uri = Uri.parse('$baseUrlSurvey/foto-tambahan/upload');
      var request = http.MultipartRequest('POST', uri);

      // --- 1. Tambahkan semua data teks ke `request.fields` ---
      textData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // --- 2. Tambahkan semua file ke `request.files` ---
      for (var entry in filesToUpload.entries) {
        final fieldName = entry.key; // misal: 'docpekerjaanimage'
        final filePaths = entry.value; // misal: ['/path/1.jpg', '/path/2.jpg']

        for (final filePath in filePaths) {
          // Buat MultipartFile untuk setiap path di dalam list
          var multipartFile = await http.MultipartFile.fromPath(
            // Gunakan '${fieldName}[]' jika backend Anda memerlukannya
            fieldName,
            filePath,
          );
          request.files.add(multipartFile);
        }
      }

      // --- DEBUG: Anda bisa cek isi request sebelum dikirim ---
      print("Sending request to ${request.url}");
      print("Fields: ${request.fields}");
      print(
          "Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}");

      // --- 3. Kirim request gabungan ---
      print(
          'Mengirim ${request.files.length} file dan ${request.fields.length} field teks ke server...');
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Data dan file-file berhasil di-upload!');
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Gagal upload: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      print('❌ Error saat upload file tambahan: $e');
      rethrow;
    }
  }
}
