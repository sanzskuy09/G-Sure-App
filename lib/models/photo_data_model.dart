import 'dart:io';
import 'package:hive/hive.dart';

part 'photo_data_model.g.dart';

@HiveType(typeId: 12) // Pastikan typeId ini UNIK
class PhotoData extends HiveObject {
  @HiveField(0)
  String? path;

  @HiveField(1)
  DateTime? timestamp;

  @HiveField(2)
  double? latitude;

  @HiveField(3)
  double? longitude;

  PhotoData({this.path, this.timestamp, this.latitude, this.longitude});

  // Factory untuk membuat objek dari Map yang Anda buat di UI
  // factory PhotoData.fromJson(Map<String, dynamic> json) {
  //   if (json.isEmpty) return PhotoData();

  //   // Ekstrak path dari objek File
  //   String? filePath;
  //   if (json['file'] != null && json['file'] is File) {
  //     filePath = (json['file'] as File).path;
  //   }

  //   return PhotoData(
  //     path: filePath,
  //     timestamp: json['timestamp'] as DateTime?,
  //     latitude: json['latitude'] as double?,
  //     longitude: json['longitude'] as double?,
  //   );
  // }

  factory PhotoData.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return PhotoData();

    // --- LOGIKA BARU UNTUK TIMESTAMP ---
    dynamic timestampValue = json['timestamp'];
    DateTime? parsedTimestamp;

    if (timestampValue is String) {
      // Jika datanya String (dari JSON/Hive), parse menjadi DateTime
      parsedTimestamp = DateTime.tryParse(timestampValue);
    } else if (timestampValue is DateTime) {
      // Jika datanya sudah DateTime (dari data baru), gunakan langsung
      parsedTimestamp = timestampValue;
    }
    // Jika null atau tipe lain, parsedTimestamp akan tetap null.

    // --- LOGIKA UNTUK FILE PATH ---
    dynamic fileValue = json['file'];
    String? filePath;

    if (fileValue is File) {
      filePath = fileValue.path;
    } else if (fileValue is String) {
      filePath = fileValue;
    } else if (json.containsKey('path')) {
      // Fallback jika key-nya 'path'
      filePath = json['path'];
    }

    return PhotoData(
      path: filePath,
      timestamp: parsedTimestamp, // ✅ Gunakan hasil parse
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'timestamp': timestamp?.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
