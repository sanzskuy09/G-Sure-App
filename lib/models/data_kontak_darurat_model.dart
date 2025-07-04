import 'package:hive/hive.dart';

part 'data_kontak_darurat_model.g.dart';

@HiveType(typeId: 6)
class DataKontakDarurat extends HiveObject {
  @HiveField(0)
  String? namakontak;
  @HiveField(1)
  String? jeniskelaminkontak;
  @HiveField(2)
  String? hubungankeluarga;
  @HiveField(3)
  String? nohpkontak;
  @HiveField(4)
  String? alamatkontak;
  @HiveField(5)
  String? kodeposkontak;

  DataKontakDarurat({
    this.namakontak,
    this.jeniskelaminkontak,
    this.hubungankeluarga,
    this.nohpkontak,
    this.alamatkontak,
    this.kodeposkontak,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'namakontak': namakontak,
        'jeniskelaminkontak': jeniskelaminkontak,
        'hubungankeluarga': hubungankeluarga,
        'nohpkontak': nohpkontak,
        'alamatkontak': alamatkontak,
        'kodeposkontak': kodeposkontak,
      };

  factory DataKontakDarurat.fromJson(Map<String, dynamic> json) =>
      DataKontakDarurat(
        namakontak: json['namakontak'],
        jeniskelaminkontak: json['jeniskelaminkontak'],
        hubungankeluarga: json['hubungankeluarga'],
        nohpkontak: json['nohpkontak'],
        alamatkontak: json['alamatkontak'],
        kodeposkontak: json['kodeposkontak'],
      );
}
