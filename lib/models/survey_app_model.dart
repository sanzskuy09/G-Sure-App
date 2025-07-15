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
  });

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'fotoTambahan': fotoTambahan
      };

  factory AplikasiSurvey.fromJson(Map<String, dynamic> json) => AplikasiSurvey(
        id: json['id'],
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
}
