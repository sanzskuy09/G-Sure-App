import 'package:hive/hive.dart';

part 'foto_legalitas_model.g.dart';

@HiveType(typeId: 10)
class FotoLegalitas extends HiveObject {
  @HiveField(0)
  String? fotoktppemohon;
  @HiveField(1)
  String? fotoktppasangan;
  @HiveField(2)
  String? fotokk;
  @HiveField(3)
  String? fotosima;
  @HiveField(4)
  String? fotonpwp;

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

  factory FotoLegalitas.fromJson(Map<String, dynamic> json) => FotoLegalitas(
        fotoktppemohon: json['fotoktppemohon'],
        fotoktppasangan: json['fotoktppasangan'],
        fotokk: json['fotokk'],
        fotosima: json['fotosima'],
        fotonpwp: json['fotonpwp'],
      );
}
