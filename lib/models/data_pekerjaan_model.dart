import 'package:hive/hive.dart';

part 'data_pekerjaan_model.g.dart';

@HiveType(typeId: 100)
class DataPekerjaan extends HiveObject {
  @HiveField(0)
  String? jenispekerjaan;
  @HiveField(1)
  String? namaperusahaan;
  @HiveField(2)
  String? jabatan;
  @HiveField(3)
  String? ketjabatan;
  @HiveField(4)
  String? alamatusaha;
  @HiveField(5)
  String? kodeposusaha;
  @HiveField(6)
  String? noteleponusaha;
  @HiveField(7)
  String? masakerjapemohon;
  @HiveField(8)
  String? gajipemohon;
  @HiveField(9)
  String? slipgajipemohon;
  @HiveField(10)
  String? payrollpemohon;
  @HiveField(11)
  String? bidangusahapemohon;
  @HiveField(12)
  String? lamausahapemohon;
  @HiveField(13)
  String? omzetusahapemohon;
  @HiveField(14)
  String? profitusahapemohon;

  DataPekerjaan({
    this.jenispekerjaan,
    this.namaperusahaan,
    this.jabatan,
    this.ketjabatan,
    this.alamatusaha,
    this.kodeposusaha,
    this.noteleponusaha,
    this.masakerjapemohon,
    this.gajipemohon,
    this.slipgajipemohon,
    this.payrollpemohon,
    this.bidangusahapemohon,
    this.lamausahapemohon,
    this.omzetusahapemohon,
    this.profitusahapemohon,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'jenispekerjaan': jenispekerjaan,
        'namaperusahaan': namaperusahaan,
        'jabatan': jabatan,
        'ketjabatan': ketjabatan,
        'alamatusaha': alamatusaha,
        'kodeposusaha': kodeposusaha,
        'noteleponusaha': noteleponusaha,
        'masakerjapemohon': masakerjapemohon,
        'gajipemohon': gajipemohon,
        'slipgajipemohon': slipgajipemohon,
        'payrollpemohon': payrollpemohon,
        'bidangusahapemohon': bidangusahapemohon,
        'lamausahapemohon': lamausahapemohon,
        'omzetusahapemohon': omzetusahapemohon,
        'profitusahapemohon': profitusahapemohon
      };

  factory DataPekerjaan.fromJson(Map<String, dynamic> json) => DataPekerjaan(
        jenispekerjaan: json['jenispekerjaan'],
        namaperusahaan: json['namaperusahaan'],
        jabatan: json['jabatan'],
        ketjabatan: json['ketjabatan'],
        alamatusaha: json['alamatusaha'],
        kodeposusaha: json['kodeposusaha'],
        noteleponusaha: json['noteleponusaha'],
        masakerjapemohon: json['masakerjapemohon'],
        gajipemohon: json['gajipemohon'],
        slipgajipemohon: json['slipgajipemohon'],
        payrollpemohon: json['payrollpemohon'],
        bidangusahapemohon: json['bidangusahapemohon'],
        lamausahapemohon: json['lamausahapemohon'],
        omzetusahapemohon: json['omzetusahapemohon'],
        profitusahapemohon: json['profitusahapemohon'],
      );
}
