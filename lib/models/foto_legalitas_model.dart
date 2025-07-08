import 'package:gsure/models/photo_data_model.dart';
import 'package:hive/hive.dart';

part 'foto_legalitas_model.g.dart';

@HiveType(typeId: 10)
class FotoLegalitas extends HiveObject {
  @HiveField(0)
  PhotoData? fotoktppemohon;
  @HiveField(1)
  PhotoData? fotoktppasangan;
  @HiveField(2)
  PhotoData? fotokk;
  @HiveField(3)
  PhotoData? fotosima;
  @HiveField(4)
  PhotoData? fotonpwp;

  FotoLegalitas({
    this.fotoktppemohon,
    this.fotoktppasangan,
    this.fotokk,
    this.fotosima,
    this.fotonpwp,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'fotoktppemohon': fotoktppemohon,
        'fotoktppasangan': fotoktppasangan,
        'fotokk': fotokk,
        'fotosima': fotosima,
        'fotonpwp': fotonpwp,
      };

  // factory FotoLegalitas.fromJson(Map<String, dynamic> json) => FotoLegalitas(
  //       fotoktppemohon: json['fotoktppemohon'],
  //       fotoktppasangan: json['fotoktppasangan'],
  //       fotokk: json['fotokk'],
  //       fotosima: json['fotosima'],
  //       fotonpwp: json['fotonpwp'],
  //     );

  // Perbarui juga factory fromJson-nya
  factory FotoLegalitas.fromJson(Map<String, dynamic> json) {
    return FotoLegalitas(
      fotoktppemohon: json['fotoktppemohon'] != null
          ? PhotoData.fromJson(json['fotoktppemohon'])
          : null,
      fotoktppasangan: json['fotoktppasangan'] != null
          ? PhotoData.fromJson(json['fotoktppasangan'])
          : null,
      fotokk:
          json['fotokk'] != null ? PhotoData.fromJson(json['fotokk']) : null,
      fotosima: json['fotosima'] != null
          ? PhotoData.fromJson(json['fotosima'])
          : null,
      fotonpwp: json['fotonpwp'] != null
          ? PhotoData.fromJson(json['fotonpwp'])
          : null,
    );
  }
}
