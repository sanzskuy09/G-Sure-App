import 'package:hive/hive.dart';

part 'data_kendaraan_model.g.dart';

@HiveType(typeId: 2)
class DataKendaraan extends HiveObject {
  @HiveField(0)
  String? kondisiKendaraan;
  @HiveField(1)
  String? merkkendaraan;
  @HiveField(2)
  String? typekendaraan;
  @HiveField(3)
  String? tahunkendaraan;
  @HiveField(4)
  String? nopolisikendaraan;
  @HiveField(5)
  String? hargakendaraan;
  @HiveField(6)
  String? uangmuka;
  @HiveField(7)
  String? pokokhutang;

  DataKendaraan({
    this.kondisiKendaraan,
    this.merkkendaraan,
    this.typekendaraan,
    this.tahunkendaraan,
    this.nopolisikendaraan,
    this.hargakendaraan,
    this.uangmuka,
    this.pokokhutang,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'kondisiKendaraan': kondisiKendaraan,
        'merkkendaraan': merkkendaraan,
        'typekendaraan': typekendaraan,
        'tahunkendaraan': tahunkendaraan,
        'nopolisikendaraan': nopolisikendaraan,
        'hargakendaraan': hargakendaraan,
        'uangmuka': uangmuka,
        'pokokhutang': pokokhutang,
      };

  factory DataKendaraan.fromJson(Map<String, dynamic> json) => DataKendaraan(
        kondisiKendaraan: json['kondisiKendaraan'],
        merkkendaraan: json['merkkendaraan'],
        typekendaraan: json['typekendaraan'],
        tahunkendaraan: json['tahunkendaraan'],
        nopolisikendaraan: json['nopolisikendaraan'],
        hargakendaraan: json['hargakendaraan'],
        uangmuka: json['uangmuka'],
        pokokhutang: json['pokokhutang'],
      );
}
