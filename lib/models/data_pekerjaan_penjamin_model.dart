import 'dart:ffi';

import 'package:hive/hive.dart';

part 'data_pekerjaan_penjamin_model.g.dart';

@HiveType(typeId: 101)
class DataPekerjaanPenjamin extends HiveObject {
  @HiveField(0)
  String? pekerjaanpenjamin;
  @HiveField(1)
  String? namaperusahaanpenjamin;
  @HiveField(2)
  String? jabatanpenjamin;
  @HiveField(3)
  String? ketjabatanpenjamin;
  @HiveField(4)
  String? alamatusahapenjamin;
  @HiveField(5)
  String? kodeposperusahaanpenjamin;
  @HiveField(6)
  String? noteleponusahapenjamin;
  @HiveField(7)
  String? masakerjapenjamin;
  @HiveField(8)
  String? gajipenjamin;
  @HiveField(9)
  String? slipgajipenjamin;
  @HiveField(10)
  String? payrollpenjamin;
  @HiveField(11)
  String? bidangusahapenjamin;
  @HiveField(12)
  String? lamausahapenjamin;
  @HiveField(13)
  String? omzetusahapenjamin;
  @HiveField(14)
  String? profitusahapenjamin;

  DataPekerjaanPenjamin({
    this.pekerjaanpenjamin,
    this.namaperusahaanpenjamin,
    this.jabatanpenjamin,
    this.ketjabatanpenjamin,
    this.alamatusahapenjamin,
    this.kodeposperusahaanpenjamin,
    this.noteleponusahapenjamin,
    this.masakerjapenjamin,
    this.gajipenjamin,
    this.slipgajipenjamin,
    this.payrollpenjamin,
    this.bidangusahapenjamin,
    this.lamausahapenjamin,
    this.omzetusahapenjamin,
    this.profitusahapenjamin,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'pekerjaanpenjamin': pekerjaanpenjamin,
        'namaperusahaanpenjamin': namaperusahaanpenjamin,
        'jabatanpenjamin': jabatanpenjamin,
        'ketjabatanpenjamin': ketjabatanpenjamin,
        'alamatusahapenjamin': alamatusahapenjamin,
        'kodeposperusahaanpenjamin': kodeposperusahaanpenjamin,
        'noteleponusahapenjamin': noteleponusahapenjamin,
        'masakerjapenjamin': masakerjapenjamin,
        'gajipenjamin': gajipenjamin,
        'slipgajipenjamin': slipgajipenjamin,
        'payrollpenjamin': payrollpenjamin,
        'bidangusahapenjamin': bidangusahapenjamin,
        'lamausahapenjamin': lamausahapenjamin,
        'omzetusahapenjamin': omzetusahapenjamin,
        'profitusahapenjamin': profitusahapenjamin
      };

  factory DataPekerjaanPenjamin.fromJson(Map<String, dynamic> json) =>
      DataPekerjaanPenjamin(
        pekerjaanpenjamin: json['pekerjaanpenjamin'],
        namaperusahaanpenjamin: json['namaperusahaanpenjamin'],
        jabatanpenjamin: json['jabatanpenjamin'],
        ketjabatanpenjamin: json['ketjabatanpenjamin'],
        alamatusahapenjamin: json['alamatusahapenjamin'],
        kodeposperusahaanpenjamin: json['kodeposperusahaanpenjamin'],
        noteleponusahapenjamin: json['noteleponusahapenjamin'],
        masakerjapenjamin: json['masakerjapenjamin'],
        gajipenjamin: json['gajipenjamin'],
        slipgajipenjamin: json['slipgajipenjamin'],
        payrollpenjamin: json['payrollpenjamin'],
        bidangusahapenjamin: json['bidangusahapenjamin'],
        lamausahapenjamin: json['lamausahapenjamin'],
        omzetusahapenjamin: json['omzetusahapenjamin'],
        profitusahapenjamin: json['profitusahapenjamin'],
      );
}
