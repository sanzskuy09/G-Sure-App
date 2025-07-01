import 'dart:convert';

import 'package:gsure/models/order_model.dart';
import 'package:gsure/shared/shared_value.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SurveyService {
  Future<List<OrderModel>> getDataListOrder() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon'));

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
}
