import 'package:gsure/models/data_alamat_survey_model.dart';
import 'package:gsure/models/data_dealer_model.dart';
import 'package:gsure/models/data_kendaraan_model.dart';
import 'package:gsure/models/data_kontak_darurat_model.dart';
import 'package:gsure/models/data_pasangan_model.dart';
import 'package:gsure/models/data_pasangan_penjamin_model.dart';
import 'package:gsure/models/data_pemohon_model.dart';
import 'package:gsure/models/data_penjamin_model.dart';
import 'package:gsure/models/foto_kendaraan_model.dart';
import 'package:gsure/models/foto_legalitas_model.dart';
import 'package:gsure/models/foto_tempat_tinggal_model.dart';
import 'package:gsure/models/photo_data_model.dart';
import 'package:hive/hive.dart';

part 'survey_app_model.g.dart';

@HiveType(typeId: 0)
class AplikasiSurvey extends HiveObject {
  @HiveField(0)
  String? id; // Untuk identifikasi unik

  @HiveField(1)
  DataDealer? dataDealer;

  @HiveField(2)
  DataKendaraan? dataKendaraan;

  @HiveField(3)
  DataAlamatSurvey? dataAlamatSurvey;

  @HiveField(4)
  DataPemohon? dataPemohon;

  @HiveField(5)
  DataPasangan? dataPasangan;

  @HiveField(6)
  DataKontakDarurat? dataKontakDarurat;

  @HiveField(7)
  String? isPenjaminExist;

  @HiveField(8)
  DataPenjamin? dataPenjamin;

  @HiveField(9)
  DataPasanganPenjamin? dataPasanganPenjamin;

  @HiveField(10)
  String? analisacmo;

  // ================= Bagian FOTO ================= //
  @HiveField(11)
  FotoKendaraan? fotoKendaraan;

  @HiveField(12)
  FotoLegalitas? fotoLegalitas;

  @HiveField(13)
  FotoTempatTinggal? fotoTempatTinggal;

  @HiveField(14)
  List<PhotoData>? fotoPekerjaan;

  @HiveField(15)
  List<PhotoData>? fotoSimulasi;

  @HiveField(16)
  List<PhotoData>? fotoTambahan;

  @HiveField(17)
  String? status;

  @HiveField(18)
  String? updatedAt;

  @HiveField(19)
  String? application_id;

  @HiveField(20)
  String? nik;

  AplikasiSurvey({
    this.id,
    this.dataDealer,
    this.dataKendaraan,
    this.dataAlamatSurvey,
    this.dataPemohon,
    this.dataPasangan,
    this.dataKontakDarurat,
    this.isPenjaminExist,
    this.dataPenjamin,
    this.dataPasanganPenjamin,
    this.analisacmo,
    this.fotoKendaraan,
    this.fotoLegalitas,
    this.fotoTempatTinggal,
    this.fotoPekerjaan, // Inisialisasi dengan list kosong
    this.fotoSimulasi,
    this.fotoTambahan,
    this.status,
    this.updatedAt,
    this.application_id,
    this.nik,
  });

  Map<String, dynamic> toJson() => {
        'fotoPekerjaan': fotoPekerjaan?.map((item) => item.toJson()).toList(),
        'fotoSimulasi': fotoSimulasi?.map((item) => item.toJson()).toList(),
        'fotoTambahan': fotoTambahan?.map((item) => item.toJson()).toList(),
        'fotoKendaraan': fotoKendaraan?.toJson(),
        'fotoLegalitas': fotoLegalitas?.toJson(),
        'fotoTempatTinggal': fotoTempatTinggal?.toJson(),
        'id': id,
        'status': status,
        'updatedAt': updatedAt,
        'application_id': application_id,
        'nik': nik,
        'dataDealer': dataDealer?.toJson(),
        'dataKendaraan': dataKendaraan?.toJson(),
        'dataAlamatSurvey': dataAlamatSurvey?.toJson(),
        'dataPemohon': dataPemohon?.toJson(),
        'dataPasangan': dataPasangan?.toJson(),
        'dataKontakDarurat': dataKontakDarurat?.toJson(),
        'isPenjaminExist': isPenjaminExist,
        'dataPenjamin': dataPenjamin?.toJson(),
        'dataPasanganPenjamin': dataPasanganPenjamin?.toJson(),
        'analisacmo': analisacmo,

        // 'fotoPekerjaan': fotoPekerjaan,
        // 'fotoSimulasi': fotoSimulasi,
        // 'fotoTambahan': fotoTambahan,
      };

  // --- METODE BARU UNTUK MERATAKAN DATA ---
  Map<String, dynamic> toFlatJson() {
    final Map<String, dynamic> flatMap = {};

    // Tambahkan properti langsung dari AplikasiSurvey
    if (id != null) flatMap['id'] = id;
    if (status != null) flatMap['status'] = status;
    if (updatedAt != null) flatMap['updatedAt'] = updatedAt;
    if (application_id != null) flatMap['application_id'] = application_id;
    if (nik != null) flatMap['nik'] = nik;
    if (isPenjaminExist != null) flatMap['isPenjaminExist'] = isPenjaminExist;
    if (analisacmo != null) flatMap['analisacmo'] = analisacmo;

    // Tambahkan properti dari sub-objek DataDealer
    if (dataDealer != null) {
      flatMap.addAll(dataDealer!.toJson());
    }
    // Tambahkan properti dari sub-objek DataKendaraan
    if (dataKendaraan != null) {
      flatMap.addAll(dataKendaraan!.toJson());
    }
    // Tambahkan properti dari sub-objek DataAlamatSurvey
    if (dataAlamatSurvey != null) {
      flatMap.addAll(dataAlamatSurvey!.toJson());
    }
    // Tambahkan properti dari sub-objek DataPemohon
    if (dataPemohon != null) {
      flatMap.addAll(dataPemohon!.toJson());
    }
    // Tambahkan properti dari sub-objek DataPasangan
    if (dataPasangan != null) {
      flatMap.addAll(dataPasangan!.toJson());
    }
    // Tambahkan properti dari sub-objek DataKontakDarurat
    if (dataKontakDarurat != null) {
      flatMap.addAll(dataKontakDarurat!.toJson());
    }
    // Tambahkan properti dari sub-objek DataPenjamin
    if (dataPenjamin != null) {
      flatMap.addAll(dataPenjamin!.toJson());
    }
    // Tambahkan properti dari sub-objek DataPasanganPenjamin
    if (dataPasanganPenjamin != null) {
      flatMap.addAll(dataPasanganPenjamin!.toJson());
    }

    if (fotoKendaraan != null) {
      flatMap.addAll(fotoKendaraan!.toJson());
    }

    if (fotoLegalitas != null) {
      flatMap.addAll(fotoLegalitas!.toJson());
    }

    if (fotoTempatTinggal != null) {
      flatMap.addAll(fotoTempatTinggal!.toJson());
    }

    // Proses fotoPekerjaan
    if (fotoPekerjaan!.isNotEmpty) {
      for (int i = 0; i < fotoPekerjaan!.length; i++) {
        // Buat key unik yang akan dikenali oleh FormProcessingService
        final key = 'dokpekerjaan${i + 1}';
        // Simpan objek PhotoData langsung, karena CameraAndUploadFieldForm sudah bisa menanganinya
        flatMap[key] = fotoPekerjaan![i];
      }
    }

    // Lakukan hal yang sama untuk fotoSimulasi
    if (fotoSimulasi!.isNotEmpty) {
      for (int i = 0; i < fotoSimulasi!.length; i++) {
        final key = 'doksimulasi${i + 1}';
        flatMap[key] = fotoSimulasi![i];
      }
    }

    // Lakukan hal yang sama untuk fotoTambahan
    if (fotoTambahan!.isNotEmpty) {
      for (int i = 0; i < fotoTambahan!.length; i++) {
        final key = 'doktambahan${i + 1}';
        flatMap[key] = fotoTambahan![i];
      }
    }

    return flatMap;
  }

  factory AplikasiSurvey.fromJson(Map<String, dynamic> json) {
    // ✅ LOGIKA BARU UNTUK MEMPROSES LIST

    // Proses fotoPekerjaan
    final pekerjaanListJson = json['fotoPekerjaan'] as List?;
    final List<PhotoData> pekerjaanList = pekerjaanListJson != null
        ? pekerjaanListJson
            .map((item) => PhotoData.fromJson(item as Map<String, dynamic>))
            .toList()
        : []; // Jika null, buat list kosong

    // Proses fotoSimulasi
    final simulasiListJson = json['fotoSimulasi'] as List?;
    final List<PhotoData> simulasiList = simulasiListJson != null
        ? simulasiListJson
            .map((item) => PhotoData.fromJson(item as Map<String, dynamic>))
            .toList()
        : [];

    // Proses fotoTambahan
    final tambahanListJson = json['fotoTambahan'] as List?;
    final List<PhotoData> tambahanList = tambahanListJson != null
        ? tambahanListJson
            .map((item) => PhotoData.fromJson(item as Map<String, dynamic>))
            .toList()
        : [];

    // Setelah semua list diproses, panggil constructor dengan `return`
    return AplikasiSurvey(
      id: json['id'],
      status: json['status'],
      updatedAt: json['updatedAt'],
      application_id: json['application_id'],
      nik: json['nik'],
      dataDealer: json['dataDealer'] != null
          ? DataDealer.fromJson(json['dataDealer'])
          : null,
      dataKendaraan: json['dataKendaraan'] != null
          ? DataKendaraan.fromJson(json['dataKendaraan'])
          : null,
      dataAlamatSurvey: json['dataAlamatSurvey'] != null
          ? DataAlamatSurvey.fromJson(json['dataAlamatSurvey'])
          : null,
      dataPemohon: json['dataPemohon'] != null
          ? DataPemohon.fromJson(json['dataPemohon'])
          : null,
      dataPasangan: json['dataPasangan'] != null
          ? DataPasangan.fromJson(json['dataPasangan'])
          : null,
      dataKontakDarurat: json['dataKontakDarurat'] != null
          ? DataKontakDarurat.fromJson(json['dataKontakDarurat'])
          : null,
      isPenjaminExist: json['isPenjaminExist'] ?? 'Tidak',
      dataPenjamin: json['dataPenjamin'] != null
          ? DataPenjamin.fromJson(json['dataPenjamin'])
          : null,
      dataPasanganPenjamin: json['dataPasanganPenjamin'] != null
          ? DataPasanganPenjamin.fromJson(json['dataPasanganPenjamin'])
          : null,
      analisacmo: json['analisacmo'] ?? '',
      fotoKendaraan: json['fotoKendaraan'] != null
          ? FotoKendaraan.fromJson(json['fotoKendaraan'])
          : null,
      fotoLegalitas: json['fotoLegalitas'] != null
          ? FotoLegalitas.fromJson(json['fotoLegalitas'])
          : null,
      fotoTempatTinggal: json['fotoTempatTinggal'] != null
          ? FotoTempatTinggal.fromJson(json['fotoTempatTinggal'])
          : null,

      // ✅ GUNAKAN LIST YANG SUDAH DIPROSES DI SINI
      fotoPekerjaan: pekerjaanList,
      fotoSimulasi: simulasiList,
      fotoTambahan: tambahanList,
    );
  }

  // factory AplikasiSurvey.fromJson(Map<String, dynamic> json) => AplikasiSurvey(
  //       id: json['id'],
  //       status: json['status'],
  //       updatedAt: json['updatedAt'],
  //       application_id: json['application_id'],
  //       nik: json['nik'],
  //       // dataDealer: DataDealer.fromJson(json),
  //       dataDealer: json['dataDealer'] != null
  //           ? DataDealer.fromJson(json['dataDealer'])
  //           : null,
  //       dataKendaraan: json['dataKendaraan'] != null
  //           ? DataKendaraan.fromJson(json['dataKendaraan'])
  //           : null,
  //       dataAlamatSurvey: json['dataAlamatSurvey'] != null
  //           ? DataAlamatSurvey.fromJson(json['dataAlamatSurvey'])
  //           : null,
  //       dataPemohon: json['dataPemohon'] != null
  //           ? DataPemohon.fromJson(json['dataPemohon'])
  //           : null,
  //       dataPasangan: json['dataPasangan'] != null
  //           ? DataPasangan.fromJson(json['dataPasangan'])
  //           : null,
  //       dataKontakDarurat: json['dataKontakDarurat'] != null
  //           ? DataKontakDarurat.fromJson(json['dataKontakDarurat'])
  //           : null,
  //       isPenjaminExist: json['isPenjaminExist'] ?? 'Tidak',
  //       dataPenjamin: json['dataPenjamin'] != null
  //           ? DataPenjamin.fromJson(json['dataPenjamin'])
  //           : null,
  //       dataPasanganPenjamin: json['dataPasanganPenjamin'] != null
  //           ? DataPasanganPenjamin.fromJson(json['dataPasanganPenjamin'])
  //           : null,
  //       analisacmo: json['analisacmo'] ?? '',
  //       fotoKendaraan: json['fotoKendaraan'] != null
  //           ? FotoKendaraan.fromJson(json['fotoKendaraan'])
  //           : null,
  //       fotoLegalitas: json['fotoLegalitas'] != null
  //           ? FotoLegalitas.fromJson(json['fotoLegalitas'])
  //           : null,
  //       fotoTempatTinggal: json['fotoTempatTinggal'] != null
  //           ? FotoTempatTinggal.fromJson(json['fotoTempatTinggal'])
  //           : null,

  //       // ✅ LOGIKA BARU UNTUK MEMPROSES LIST

  //       // fotoPekerjaanPaths: json['fotoPekerjaanPaths'] ?? [],
  //       // fotoSimulasiPaths: json['fotoSimulasiPaths'] ?? [],
  //       // fotoTambahanPaths: json['fotoTambahanPaths'] ?? [],
  //     );

  AplikasiSurvey copyWith({
    String? id,
    DataDealer? dataDealer,
    DataKendaraan? dataKendaraan,
    DataAlamatSurvey? dataAlamatSurvey,
    DataPemohon? dataPemohon,
    DataPasangan? dataPasangan,
    DataKontakDarurat? dataKontakDarurat,
    String? isPenjaminExist,
    DataPenjamin? dataPenjamin,
    DataPasanganPenjamin? dataPasanganPenjamin,
    String? analisacmo,
    FotoKendaraan? fotoKendaraan,
    FotoLegalitas? fotoLegalitas,
    FotoTempatTinggal? fotoTempatTinggal,
    List<PhotoData>? fotoPekerjaan,
    List<PhotoData>? fotoSimulasi,
    List<PhotoData>? fotoTambahan,
    String? status,
    String? updatedAt,
    String? application_id,
    String? nik,
  }) {
    return AplikasiSurvey(
      id: id ?? this.id,
      dataDealer: dataDealer ?? this.dataDealer,
      dataKendaraan: dataKendaraan ?? this.dataKendaraan,
      dataAlamatSurvey: dataAlamatSurvey ?? this.dataAlamatSurvey,
      dataPemohon: dataPemohon ?? this.dataPemohon,
      dataPasangan: dataPasangan ?? this.dataPasangan,
      dataKontakDarurat: dataKontakDarurat ?? this.dataKontakDarurat,
      isPenjaminExist: isPenjaminExist ?? this.isPenjaminExist,
      dataPenjamin: dataPenjamin ?? this.dataPenjamin,
      dataPasanganPenjamin: dataPasanganPenjamin ?? this.dataPasanganPenjamin,
      analisacmo: analisacmo ?? this.analisacmo,
      fotoKendaraan: fotoKendaraan ?? this.fotoKendaraan,
      fotoLegalitas: fotoLegalitas ?? this.fotoLegalitas,
      fotoTempatTinggal: fotoTempatTinggal ?? this.fotoTempatTinggal,
      fotoPekerjaan: fotoPekerjaan ?? this.fotoPekerjaan,
      fotoSimulasi: fotoSimulasi ?? this.fotoSimulasi,
      fotoTambahan: fotoTambahan ?? this.fotoTambahan,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      application_id: application_id ?? this.application_id,
      nik: nik ?? this.nik,
    );
  }
}
