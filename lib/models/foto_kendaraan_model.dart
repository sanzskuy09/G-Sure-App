import 'dart:ffi';

import 'package:hive/hive.dart';

part 'foto_kendaraan_model.g.dart';

@HiveType(typeId: 9)
class FotoKendaraan extends HiveObject {
  @HiveField(0)
  String? odometer;
  @HiveField(1)
  String? fotounitdepan;
  @HiveField(2)
  String? fotounitbelakang;
  @HiveField(3)
  String? fotounitinteriordepan;
  @HiveField(4)
  String? fotounitmesinplat;
  @HiveField(5)
  String? fotomesin;
  @HiveField(6)
  String? fotounitselfiecmo;
  @HiveField(7)
  String? fotospeedometer;
  @HiveField(8)
  String? fotogesekannoka;
  @HiveField(9)
  String? fotostnk;
  @HiveField(10)
  String? fotonoticepajak;
  @HiveField(11)
  String? fotobpkb1;
  @HiveField(12)
  String? fotobpkb2;

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

  factory FotoKendaraan.fromJson(Map<String, dynamic> json) => FotoKendaraan(
        odometer: json['odometer'],
        fotounitdepan: json['fotounitdepan'],
        fotounitbelakang: json['fotounitbelakang'],
        fotounitinteriordepan: json['fotounitinteriordepan'],
        fotounitmesinplat: json['fotounitmesinplat'],
        fotomesin: json['fotomesin'],
        fotounitselfiecmo: json['fotounitselfiecmo'],
        fotospeedometer: json['fotospeedometer'],
        fotogesekannoka: json['fotogesekannoka'],
        fotostnk: json['fotostnk'],
        fotonoticepajak: json['fotonoticepajak'],
        fotobpkb1: json['fotobpkb1'],
        fotobpkb2: json['fotobpkb2'],
      );
}
