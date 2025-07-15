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
  factory PhotoData.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return PhotoData();

    // Ekstrak path dari objek File
    String? filePath;
    if (json['file'] != null && json['file'] is File) {
      filePath = (json['file'] as File).path;
    }

    return PhotoData(
      path: filePath,
      timestamp: json['timestamp'] as DateTime?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }
}
