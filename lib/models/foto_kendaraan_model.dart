import 'package:gsure/models/photo_data_model.dart';
import 'package:hive/hive.dart';

part 'foto_kendaraan_model.g.dart';

@HiveType(typeId: 9)
class FotoKendaraan extends HiveObject {
  @HiveField(0)
  String? odometer;
  @HiveField(1)
  PhotoData? fotounitdepan;
  @HiveField(2)
  PhotoData? fotounitbelakang;
  @HiveField(3)
  PhotoData? fotounitinteriordepan;
  @HiveField(4)
  PhotoData? fotounitmesinplat;
  @HiveField(5)
  PhotoData? fotomesin;
  @HiveField(6)
  PhotoData? fotounitselfiecmo;
  @HiveField(7)
  PhotoData? fotospeedometer;
  @HiveField(8)
  PhotoData? fotogesekannoka;
  @HiveField(9)
  PhotoData? fotostnk;
  @HiveField(10)
  PhotoData? fotonoticepajak;
  @HiveField(11)
  PhotoData? fotobpkb1;
  @HiveField(12)
  PhotoData? fotobpkb2;

  FotoKendaraan({
    this.odometer,
    this.fotounitdepan,
    this.fotounitbelakang,
    this.fotounitinteriordepan,
    this.fotounitmesinplat,
    this.fotomesin,
    this.fotounitselfiecmo,
    this.fotospeedometer,
    this.fotogesekannoka,
    this.fotostnk,
    this.fotonoticepajak,
    this.fotobpkb1,
    this.fotobpkb2,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'odometer': odometer,
        'fotounitdepan': fotounitdepan,
        'fotounitbelakang': fotounitbelakang,
        'fotounitinteriordepan': fotounitinteriordepan,
        'fotounitmesinplat': fotounitmesinplat,
        'fotomesin': fotomesin,
        'fotounitselfiecmo': fotounitselfiecmo,
        'fotospeedometer': fotospeedometer,
        'fotogesekannoka': fotogesekannoka,
        'fotostnk': fotostnk,
        'fotonoticepajak': fotonoticepajak,
        'fotobpkb1': fotobpkb1,
        'fotobpkb2': fotobpkb2,
      };

  // Perbarui juga factory fromJson-nya
  factory FotoKendaraan.fromJson(Map<String, dynamic> json) {
    return FotoKendaraan(
      odometer: json['odometer'],
      fotounitdepan: json['fotounitdepan'] != null
          ? PhotoData.fromJson(json['fotounitdepan'])
          : null,
      fotounitbelakang: json['fotounitbelakang'] != null
          ? PhotoData.fromJson(json['fotounitbelakang'])
          : null,
      fotounitinteriordepan: json['fotounitinteriordepan'] != null
          ? PhotoData.fromJson(json['fotounitinteriordepan'])
          : null,
      fotounitmesinplat: json['fotounitmesinplat'] != null
          ? PhotoData.fromJson(json['fotounitmesinplat'])
          : null,
      fotomesin: json['fotomesin'] != null
          ? PhotoData.fromJson(json['fotomesin'])
          : null,
      fotounitselfiecmo: json['fotounitselfiecmo'] != null
          ? PhotoData.fromJson(json['fotounitselfiecmo'])
          : null,
      fotospeedometer: json['fotospeedometer'] != null
          ? PhotoData.fromJson(json['fotospeedometer'])
          : null,
      fotogesekannoka: json['fotogesekannoka'] != null
          ? PhotoData.fromJson(json['fotogesekannoka'])
          : null,
      fotostnk: json['fotostnk'] != null
          ? PhotoData.fromJson(json['fotostnk'])
          : null,
      fotonoticepajak: json['fotonoticepajak'] != null
          ? PhotoData.fromJson(json['fotonoticepajak'])
          : null,
      fotobpkb1: json['fotobpkb1'] != null
          ? PhotoData.fromJson(json['fotobpkb1'])
          : null,
      fotobpkb2: json['fotobpkb2'] != null
          ? PhotoData.fromJson(json['fotobpkb2'])
          : null,
      // ... dan seterusnya untuk semua field foto
    );
  }
}
