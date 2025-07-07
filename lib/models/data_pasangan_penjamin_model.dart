import 'dart:ffi';

import 'package:hive/hive.dart';

part 'data_pasangan_penjamin_model.g.dart';

@HiveType(typeId: 8)
class DataPasanganPenjamin extends HiveObject {
  @HiveField(0)
  String? namapasanganpenjamin;
  @HiveField(1)
  String? agamapasanganpenjamin;
  @HiveField(2)
  String? warganegarapasanganpenjamin;
  @HiveField(3)
  String? notelponpasanganpenjamin;
  @HiveField(4)
  String? nowapasanganpenjamin;

  // @HiveField(17)
  // DataPekerjaan? dataPekerjaan;

  //pekerjaan pasangan
  @HiveField(5)
  String? pekerjaanpasanganpenjamin;
  @HiveField(6)
  String? namaperusahaanpasanganpenjamin;
  @HiveField(7)
  String? jabatanpasanganpenjamin;
  @HiveField(8)
  String? ketjabatanpasanganpenjamin;
  @HiveField(9)
  String? alamatperusahaanpasanganpenjamin;
  @HiveField(10)
  String? kodeposperusahaanpasanganpenjamin;
  @HiveField(11)
  String? noteleponusahapasanganpenjamin;
  @HiveField(12)
  String? masakerjapasanganpenjamin;
  @HiveField(13)
  String? gajipasanganpenjamin;
  @HiveField(14)
  String? slipgajipasanganpenjamin;
  @HiveField(15)
  String? payrollpasanganpenjamin;
  @HiveField(16)
  String? bidangusahapasanganpenjamin;
  @HiveField(17)
  String? lamausahapasanganpenjamin;
  @HiveField(18)
  String? omzetusahapasanganpenjamin;
  @HiveField(19)
  String? profitusahapasanganpenjamin;

  DataPasanganPenjamin({
    this.namapasanganpenjamin,
    this.agamapasanganpenjamin,
    this.warganegarapasanganpenjamin,
    this.notelponpasanganpenjamin,
    this.nowapasanganpenjamin,
    // this.dataPekerjaan,
    this.pekerjaanpasanganpenjamin,
    this.namaperusahaanpasanganpenjamin,
    this.jabatanpasanganpenjamin,
    this.ketjabatanpasanganpenjamin,
    this.alamatperusahaanpasanganpenjamin,
    this.kodeposperusahaanpasanganpenjamin,
    this.noteleponusahapasanganpenjamin,
    this.masakerjapasanganpenjamin,
    this.gajipasanganpenjamin,
    this.slipgajipasanganpenjamin,
    this.payrollpasanganpenjamin,
    this.bidangusahapasanganpenjamin,
    this.lamausahapasanganpenjamin,
    this.omzetusahapasanganpenjamin,
    this.profitusahapasanganpenjamin,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'namapasanganpenjamin': namapasanganpenjamin,
        'agamapasanganpenjamin': agamapasanganpenjamin,
        'warganegarapasanganpenjamin': warganegarapasanganpenjamin,
        'notelponpasanganpenjamin': notelponpasanganpenjamin,
        'nowapasanganpenjamin': nowapasanganpenjamin,
        // 'dataPekerjaan': dataPekerjaan?.toJson(),
        'pekerjaanpasanganpenjamin': pekerjaanpasanganpenjamin,
        'namaperusahaanpasanganpenjamin': namaperusahaanpasanganpenjamin,
        'jabatanpasanganpenjamin': jabatanpasanganpenjamin,
        'ketjabatanpasanganpenjamin': ketjabatanpasanganpenjamin,
        'alamatperusahaanpasanganpenjamin': alamatperusahaanpasanganpenjamin,
        'kodeposperusahaanpasanganpenjamin': kodeposperusahaanpasanganpenjamin,
        'noteleponusahapasanganpenjamin': noteleponusahapasanganpenjamin,
        'masakerjapasanganpenjamin': masakerjapasanganpenjamin,
        'gajipasanganpenjamin': gajipasanganpenjamin,
        'slipgajipasanganpenjamin': slipgajipasanganpenjamin,
        'payrollpasanganpenjamin': payrollpasanganpenjamin,
        'bidangusahapasanganpenjamin': bidangusahapasanganpenjamin,
        'lamausahapasanganpenjamin': lamausahapasanganpenjamin,
        'omzetusahapasanganpenjamin': omzetusahapasanganpenjamin,
        'profitusahapasanganpenjamin': profitusahapasanganpenjamin
      };

  factory DataPasanganPenjamin.fromJson(Map<String, dynamic> json) =>
      DataPasanganPenjamin(
        namapasanganpenjamin: json['namapasanganpenjamin'],
        agamapasanganpenjamin: json['agamapasanganpenjamin'],
        warganegarapasanganpenjamin: json['warganegarapasanganpenjamin'],
        notelponpasanganpenjamin: json['notelponpasanganpenjamin'],
        nowapasanganpenjamin: json['nowapasanganpenjamin'],
        // dataPekerjaan: json['dataPekerjaan'] != null
        //     ? DataPekerjaan.fromJson(json['dataPekerjaan'])
        //     : null,
        pekerjaanpasanganpenjamin: json['pekerjaanpasanganpenjamin'],
        namaperusahaanpasanganpenjamin: json['namaperusahaanpasanganpenjamin'],
        jabatanpasanganpenjamin: json['jabatanpasanganpenjamin'],
        ketjabatanpasanganpenjamin: json['ketjabatanpasanganpenjamin'],
        alamatperusahaanpasanganpenjamin:
            json['alamatperusahaanpasanganpenjamin'],
        kodeposperusahaanpasanganpenjamin:
            json['kodeposperusahaanpasanganpenjamin'],
        noteleponusahapasanganpenjamin: json['noteleponusahapasanganpenjamin'],
        masakerjapasanganpenjamin: json['masakerjapasanganpenjamin'],
        gajipasanganpenjamin: json['gajipasanganpenjamin'],
        slipgajipasanganpenjamin: json['slipgajipasanganpenjamin'],
        payrollpasanganpenjamin: json['payrollpasanganpenjamin'],
        bidangusahapasanganpenjamin: json['bidangusahapasanganpenjamin'],
        lamausahapasanganpenjamin: json['lamausahapasanganpenjamin'],
        omzetusahapasanganpenjamin: json['omzetusahapasanganpenjamin'],
        profitusahapasanganpenjamin: json['profitusahapasanganpenjamin'],
      );
}
