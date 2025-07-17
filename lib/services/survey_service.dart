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
      print('Terjadi error saat mengirim data survey: $e');
      rethrow;
    }
  }
}
