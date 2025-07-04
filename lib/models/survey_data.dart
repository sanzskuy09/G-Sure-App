import 'dart:io';
import 'package:hive/hive.dart';

// Jalankan 'flutter packages pub run build_runner build' setelah membuat file ini
part 'survey_data.g.dart';

@HiveType(typeId: 2222) // typeId harus unik untuk setiap model
class SurveyData extends HiveObject {
  @HiveField(0)
  String? kddealer;

  @HiveField(1)
  String? statuspernikahan;

  @HiveField(2)
  String? pekerjaan;

  @HiveField(3)
  String? nama;

  @HiveField(4)
  String? hargakendaraan;

  @HiveField(5)
  String? rt;

  @HiveField(6)
  String? rw;

  @HiveField(7)
  String? kodepos;

  @HiveField(8)
  String? odometer;

  // Kita simpan path filenya sebagai String
  @HiveField(9)
  String? fotounitdepanPath;

  @HiveField(10)
  String? fotostnkPath;

  @HiveField(11)
  String? namapasangan;

  @HiveField(12)
  String? isPenjamin;

  @HiveField(13)
  String? telppenjamin;

  // Tambahkan field lain sesuai kebutuhan form Anda
  @HiveField(14)
  String? dokumen1Path;

  // Fungsi helper untuk mempermudah konversi dari Map
  static SurveyData fromFormAnswers(Map<String, dynamic> formAnswers) {
    final survey = SurveyData()
      ..kddealer = formAnswers['kddealer']?.toString()
      ..statuspernikahan = formAnswers['statuspernikahan']?.toString()
      ..pekerjaan = formAnswers['pekerjaan']?.toString()
      ..nama = formAnswers['nama']?.toString()
      ..hargakendaraan = formAnswers['hargakendaraan']?.toString()
      ..rt = formAnswers['rt']?.toString()
      ..rw = formAnswers['rw']?.toString()
      ..kodepos = formAnswers['kodepos']?.toString()
      ..odometer = formAnswers['odometer']?.toString()
      ..namapasangan = formAnswers['namapasangan']?.toString()
      ..isPenjamin = formAnswers['isPenjamin']?.toString()
      ..telppenjamin = formAnswers['telppenjamin']?.toString();

    // Konversi data file menjadi path string
    if (formAnswers['fotouniTdepan'] is Map) {
      final file = (formAnswers['fotouniTdepan']['file'] as File?);
      survey.fotounitdepanPath = file?.path;
    }
    if (formAnswers['fotostnk'] is Map) {
      final file = (formAnswers['fotostnk']['file'] as File?);
      survey.fotostnkPath = file?.path;
    }
    if (formAnswers['dokumen1'] is Map) {
      final file = (formAnswers['dokumen1']['file'] as File?);
      survey.dokumen1Path = file?.path;
    }

    return survey;
  }
}
