import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gsure/models/login_model.dart';
import 'package:gsure/models/user_model.dart';
import 'package:gsure/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  // Register

  Future<UserModel> login(LoginModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/user/login'),
        body: data.toJson(),
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        // body: jsonEncode(data.toJson()),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final user = UserModel.fromJson(body['data']['user']);
        await storeCredential(user);

        return user;
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<UserModel> login(LoginModel data) async {
  //   try {
  //     // 1. Muat file JSON dari assets
  //     final String response = await rootBundle.loadString('assets/user.json');
  //     final List<dynamic> userList = json.decode(response);

  //     // 2. Cari user yang cocok berdasarkan username dan password
  //     final userFound = userList.firstWhere(
  //       (user) =>
  //           user['username'] == data.username &&
  //           user['password'] == data.password,
  //       // Jika tidak ada user yang cocok, `orElse` akan dieksekusi
  //       orElse: () => null,
  //     );

  //     // 3. Proses hasilnya
  //     if (userFound != null) {
  //       // Jika user ditemukan, konversi ke UserModel
  //       final user = UserModel.fromJson(userFound);

  //       // Simpan kredensial (token & username) seperti sebelumnya
  //       await storeCredential(user);

  //       // Kembalikan data user yang berhasil login
  //       return user;
  //     } else {
  //       // Jika tidak ditemukan, lempar Exception
  //       // Ini akan ditangkap oleh BLoC dan diubah menjadi AuthFailed
  //       throw Exception('Username atau Password Salah');
  //     }
  //   } catch (e) {
  //     rethrow; // Lempar kembali error untuk ditangani BLoC
  //   }
  // }

  Future<void> storeCredential(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();

      await storage.write(key: 'username', value: user.username);
      await storage.write(key: 'password', value: user.password);
      await storage.write(key: 'token', value: user.token);
      // await storage.write(key: 'password', value: user.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginModel> loginFromCredential() async {
    try {
      const storage = FlutterSecureStorage();

      Map<String, String> values = await storage.readAll();
      if (values['username'] == null && values['token'] == null) {
        throw 'Silahkan login terlebih dahulu';
      } else {
        // return LoginModel(username: values['username'], password: values['password']);
        final LoginModel data = LoginModel(
            username: values['username'], password: values['password']);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    try {
      String token = '';
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: 'token');

      if (value != null) {
        token = value;
      }

      return 'Bearer $token';
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> verifyToken(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/auth/check'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return UserModel.fromJson(body['data']['user']);
    } else {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }

  Future<void> clearAllStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  // METHOD BARU UNTUK MENGAMBIL USER DARI STORAGE
  Future<UserModel> getUserFromStorage() async {
    try {
      // 1. Baca username/token dari secure storage
      const storage = FlutterSecureStorage();
      String? username = await storage.read(key: 'username');

      if (username == null) {
        throw Exception('User not logged in');
      }

      // 2. Baca file user.json
      final String response = await rootBundle.loadString('assets/user.json');
      final List<dynamic> userList = json.decode(response);

      // 3. Cari user yang cocok berdasarkan username yang tersimpan
      final userFound = userList.firstWhere(
        (user) => user['username'] == username,
        orElse: () => null,
      );

      if (userFound != null) {
        // 4. Jika ditemukan, kembalikan UserModel
        return UserModel.fromJson(userFound);
      } else {
        throw Exception('User data not found in JSON');
      }
    } catch (e) {
      rethrow;
    }
  }
}
