import 'dart:convert';

import 'package:gsure/models/order_model.dart';
import 'package:gsure/services/logger_services.dart';
import 'package:gsure/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class SurveyService {
  Future<List<OrderModel>> getDataListOrder(String username) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon/order/$username'));
      // final res =
      //     await http.get(Uri.parse('$baseUrlGratama/pemohon/order/$username'));

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
    final Uri url = Uri.parse('$baseUrlSurvey/alldata');
    // final Uri url = Uri.parse('$baseUrlSurveyGratama/alldata');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ambil application_id dari nested map dealer
        final appId = data['dealer']?['application_id'];
        if (appId != null) {
          final Uri urlUpdate =
              Uri.parse('$baseUrl/pemohon/order/update/$appId');
          // Uri.parse('$baseUrlGratama/pemohon/order/update/$appId');

          final updateResponse = await http.put(
            urlUpdate,
            headers: {
              'Content-Type': 'application/json',
            },
          );

          if (updateResponse.statusCode == 200 ||
              updateResponse.statusCode == 201) {
            AppLogger.w('✅ Status berhasil diupdate!');
          } else {
            throw Exception(
                'Gagal update status. Status: ${updateResponse.statusCode}, Body: ${updateResponse.body}');
          }
        } else {
          throw Exception('application_id tidak ditemukan di data.dealer!');
        }
      } else if (response.statusCode == 500) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        if (body['error'] == 'Validation error') {
          AppLogger.w('data sudah dikirim. lanjut kirim upload foto saja!!');
        } else {
          throw Exception(
              'Gagal mengirim data. Status: ${response.statusCode}, Body: ${response.body}');
        }
      } else {
        throw Exception(
            'Gagal mengirim data. Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Menangani error koneksi atau lainnya
      // print('Terjadi error saat mengirim data survey non file: $e');
      rethrow;
    }
  }

  // Future<void> fileUploadService(Map<String, dynamic> data) async {
  //   final Uri url =
  //       Uri.parse('$baseUrlSurvey/api/foto-dokumen/upload/multiple');
  //   // final Uri url =
  //   //     Uri.parse('$baseUrlSurveyGratama/api/foto-dokumen/upload/multiple');

  //   try {
  //     print('ini data $data');
  //     // final response = await http.post(
  //     //   url,
  //     //   headers: {
  //     //     'Content-Type': 'application/json',
  //     //   },
  //     //   body: jsonEncode(data),
  //     // );

  //     // // 200 (OK) atau 201 (Created) biasanya menandakan sukses
  //     // if (response.statusCode == 200 || response.statusCode == 201) {
  //     //   print('Data survey berhasil dikirim!');
  //     // } else {
  //     //   throw Exception(
  //     //       'Gagal mengirim data. Status: ${response.statusCode}, Body: ${response.body}');
  //     // }
  //   } catch (e) {
  //     print('Terjadi error saat mengirim foto survey: $e');
  //     rethrow;
  //   }
  // }

  Future<void> uploadSurveyFiles({
    required Map<String, String> filesToUpload,
    required Map<String, dynamic> textData,
  }) async {
    try {
      // print('filesToUpload $filesToUpload');

      var uri = Uri.parse('$baseUrlSurvey/foto-dokumen/upload/multiple');
      // var uri = Uri.parse('$baseUrlSurveyGratama/foto-dokumen/upload/multiple');
      var request = http.MultipartRequest('POST', uri);

      textData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      for (var entry in filesToUpload.entries) {
        final fieldName = entry.key; // misal: 'fotounitdepan'
        final filePath =
            entry.value; // misal: '/data/user/0/.../fotounitdepan_123.jpg'

        var multipartFile =
            await http.MultipartFile.fromPath(fieldName, filePath);

        request.files.add(multipartFile);
      }

      // // ✅ TAMBAHKAN BLOK DEBUGGING INI
      // // =================================================================
      // print("===================================");
      // print("🔍 DETAIL REQUEST SEBELUM DIKIRIM");
      // print("===================================");
      // print("URL: ${request.method} ${request.url}");
      // print("Headers: ${request.headers}");

      // print("\n--- Fields (Data Teks) ---");
      // request.fields.forEach((key, value) {
      //   print("  $key: $value");
      // });

      // print("\n--- Files (Data Gambar/File) ---");
      // for (var file in request.files) {
      //   print("  Field Name: ${file.field}");
      //   print("    Filename: ${file.filename}");
      //   print("    Length: ${file.length} bytes");
      //   print("    Content-Type: ${file.contentType}");
      // }
      // print("===================================");
      // // =================================================================

      // // --- 3. Kirim request ---
      // print('Mengirim ${request.files.length} file ke server...');
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.w('✅ File-file berhasil di-upload!');
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Gagal upload file: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      // print('❌ Error saat upload file: $e');
      rethrow;
    }
  }

  Future<void> uploadTambahanSurveyFiles({
    required Map<String, List<String>> filesToUpload,
    required Map<String, dynamic> textData,
  }) async {
    try {
      var uri = Uri.parse('$baseUrlSurvey/foto-tambahan/upload');
      // var uri = Uri.parse('$baseUrlSurveyGratama/foto-tambahan/upload');
      var request = http.MultipartRequest('POST', uri);

      textData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      for (var entry in filesToUpload.entries) {
        final fieldName = entry.key; // misal: 'docpekerjaanimage'
        final filePaths = entry.value; // misal: ['/path/1.jpg', '/path/2.jpg']

        for (final filePath in filePaths) {
          var multipartFile = await http.MultipartFile.fromPath(
            fieldName,
            filePath,
          );
          request.files.add(multipartFile);
        }
      }

      // print("Sending request to ${request.url}");
      // print("Fields: ${request.fields}");
      // print(
      //     "Files: ${request.files.map((f) => '${f.field}: ${f.filename}').toList()}");

      // // --- 3. Kirim request gabungan ---
      // print(
      //     'Mengirim ${request.files.length} file dan ${request.fields.length} field teks ke server...');
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final appId = request.fields['application_id'];
        if (appId != null) {
          final Uri urlUpdate =
              Uri.parse('$baseUrl/pemohon/order/update/$appId');
          // Uri.parse('$baseUrlGratama/pemohon/order/update/$appId');

          final updateResponse = await http.put(
            urlUpdate,
            headers: {
              'Content-Type': 'application/json',
            },
          );

          if (updateResponse.statusCode == 200 ||
              updateResponse.statusCode == 201) {
            AppLogger.w('✅ Status berhasil diupdate!');

            // print('Status berhasil diupdate!');
          } else {
            // print(
            //     'Gagal update status. Status: ${updateResponse.statusCode}, Body: ${updateResponse.body}');
            throw Exception(
                'Gagal update status. Status: ${updateResponse.statusCode}, Body: ${updateResponse.body}');
          }
        } else {
          throw Exception('application_id tidak ditemukan');
        }
      } else {
        final respStr = await response.stream.bytesToString();
        throw Exception('Gagal upload: ${response.statusCode} - $respStr');
      }
    } catch (e) {
      // print('❌ Error saat upload file tambahan: $e');
      rethrow;
    }
  }
}
