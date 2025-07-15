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
    this.fotoPekerjaan = const [], // Inisialisasi dengan list kosong
    this.fotoSimulasi = const [],
    this.fotoTambahan = const [],
    this.status,
    this.updatedAt,
    this.application_id,
    this.nik,
  });

  Map<String, dynamic> toJson() => {
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
        'fotoKendaraan': fotoKendaraan?.toJson(),
        'fotoLegalitas': fotoLegalitas?.toJson(),
        'fotoTempatTinggal': fotoTempatTinggal?.toJson(),
        'fotoPekerjaan': fotoPekerjaan,
        'fotoSimulasi': fotoSimulasi,
        'fotoTambahan': fotoTambahan,
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

    // --- Perbaikan Bagian FOTO (objek yang berisi banyak PhotoData) ---
    // Karena FotoKendaraan, FotoLegalitas, FotoTempatTinggal sudah berisi PhotoData,
    // kita cukup meratakan hasil toJson() dari masing-masing objek tersebut.
    // Ini akan menambahkan properti seperti 'odometer', 'fotounitdepan', dll. langsung ke flatMap.
    if (fotoKendaraan != null) {
      flatMap.addAll(fotoKendaraan!.toJson());
    }
    if (fotoLegalitas != null) {
      flatMap.addAll(fotoLegalitas!.toJson());
    }
    if (fotoTempatTinggal != null) {
      flatMap.addAll(fotoTempatTinggal!.toJson());
    }

    // Untuk List<PhotoData> (fotoPekerjaan, fotoSimulasi, fotoTambahan)
    // Kita perlu mengubah setiap PhotoData di dalam list menjadi Map menggunakan toJson()
    // dan menyimpannya sebagai list di dalam flatMap.
    // if (fotoPekerjaan != null && fotoPekerjaan!.isNotEmpty) {
    //   flatMap['fotoPekerjaan'] = fotoPekerjaan!.map((e) => e.toJson()).toList();
    // } else {
    //   flatMap['fotoPekerjaan'] = []; // Pastikan selalu ada list kosong jika tidak ada foto
    // }
    // if (fotoSimulasi != null && fotoSimulasi!.isNotEmpty) {
    //   flatMap['fotoSimulasi'] = fotoSimulasi!.map((e) => e.toJson()).toList();
    // } else {
    //   flatMap['fotoSimulasi'] = [];
    // }
    // if (fotoTambahan != null && fotoTambahan!.isNotEmpty) {
    //   flatMap['fotoTambahan'] = fotoTambahan!.map((e) => e.toJson()).toList();
    // } else {
    //   flatMap['fotoTambahan'] = [];
    // }

    return flatMap;
  }

  factory AplikasiSurvey.fromJson(Map<String, dynamic> json) => AplikasiSurvey(
        id: json['id'],
        status: json['status'],
        updatedAt: json['updatedAt'],
        application_id: json['application_id'],
        nik: json['nik'],
        // dataDealer: DataDealer.fromJson(json),
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

        // Logika untuk mengubah list of map menjadi list of PhotoData object
        fotoPekerjaan: (json['fotoPekerjaan'] as List<dynamic>?)
                ?.map(
                    (item) => PhotoData.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],

        fotoSimulasi: (json['fotoSimulasi'] as List<dynamic>?)
                ?.map(
                    (item) => PhotoData.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],

        fotoTambahan: (json['fotoTambahan'] as List<dynamic>?)
                ?.map(
                    (item) => PhotoData.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        // fotoPekerjaanPaths: json['fotoPekerjaanPaths'] ?? [],
        // fotoSimulasiPaths: json['fotoSimulasiPaths'] ?? [],
        // fotoTambahanPaths: json['fotoTambahanPaths'] ?? [],
      );

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
