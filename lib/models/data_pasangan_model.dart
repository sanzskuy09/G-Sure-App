import 'dart:ffi';

import 'package:hive/hive.dart';

part 'data_pasangan_model.g.dart';

@HiveType(typeId: 5)
class DataPasangan extends HiveObject {
  @HiveField(0)
  String? namapasangan;
  @HiveField(1)
  String? namapanggilan;
  @HiveField(2)
  String? ktppasangan;
  @HiveField(3)
  String? agamapasangan;
  @HiveField(4)
  String? warganegarapasangan;
  @HiveField(5)
  String? notelppasangan;
  @HiveField(6)
  String? nohppasangan;

  // @HiveField(17)
  // DataPekerjaan? dataPekerjaan;

  //pekerjaan pasangan
  @HiveField(7)
  String? pekerjaanpasangan;
  @HiveField(8)
  String? namaperusahaanpasangan;
  @HiveField(9)
  String? jabatanpasangan;
  @HiveField(10)
  String? ketjabatanpasangan;
  @HiveField(11)
  String? alamatusahapasangan;
  @HiveField(12)
  String? kodeposperusahaanpasangan;
  @HiveField(13)
  String? noteleponusahapasangan;
  @HiveField(14)
  String? masakerjapasangan;
  @HiveField(15)
  Double? gajipasangan;
  @HiveField(16)
  String? slipgajipasangan;
  @HiveField(17)
  String? payrollpasangan;
  @HiveField(18)
  String? bidangusahapasangan;
  @HiveField(19)
  String? lamausahapasangan;
  @HiveField(20)
  Double? omzetusahapasangan;
  @HiveField(21)
  String? profitusahapasangan;

  DataPasangan({
    this.namapasangan,
    this.namapanggilan,
    this.ktppasangan,
    this.agamapasangan,
    this.warganegarapasangan,
    this.notelppasangan,
    this.nohppasangan,
    // this.dataPekerjaan,
    this.pekerjaanpasangan,
    this.namaperusahaanpasangan,
    this.jabatanpasangan,
    this.ketjabatanpasangan,
    this.alamatusahapasangan,
    this.kodeposperusahaanpasangan,
    this.noteleponusahapasangan,
    this.masakerjapasangan,
    this.gajipasangan,
    this.slipgajipasangan,
    this.payrollpasangan,
    this.bidangusahapasangan,
    this.lamausahapasangan,
    this.omzetusahapasangan,
    this.profitusahapasangan,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'namapasangan': namapasangan,
        'namapanggilan': namapanggilan,
        'ktppasangan': ktppasangan,
        'agamapasangan': agamapasangan,
        'warganegarapasangan': warganegarapasangan,
        'notelppasangan': notelppasangan,
        'nohppasangan': nohppasangan,
        // 'dataPekerjaan': dataPekerjaan?.toJson(),
        'pekerjaanpasangan': pekerjaanpasangan,
        'namaperusahaanpasangan': namaperusahaanpasangan,
        'jabatanpasangan': jabatanpasangan,
        'ketjabatanpasangan': ketjabatanpasangan,
        'alamatusahapasangan': alamatusahapasangan,
        'kodeposperusahaanpasangan': kodeposperusahaanpasangan,
        'noteleponusahapasangan': noteleponusahapasangan,
        'masakerjapasangan': masakerjapasangan,
        'gajipasangan': gajipasangan,
        'slipgajipasangan': slipgajipasangan,
        'payrollpasangan': payrollpasangan,
        'bidangusahapasangan': bidangusahapasangan,
        'lamausahapasangan': lamausahapasangan,
        'omzetusahapasangan': omzetusahapasangan,
        'profitusahapasangan': profitusahapasangan
      };

  factory DataPasangan.fromJson(Map<String, dynamic> json) => DataPasangan(
        namapasangan: json['namapasangan'],
        namapanggilan: json['namapanggilan'],
        ktppasangan: json['ktppasangan'],
        agamapasangan: json['agamapasangan'],
        warganegarapasangan: json['warganegarapasangan'],
        notelppasangan: json['notelppasangan'],
        nohppasangan: json['nohppasangan'],
        // dataPekerjaan: json['dataPekerjaan'] != null
        //     ? DataPekerjaan.fromJson(json['dataPekerjaan'])
        //     : null,
        pekerjaanpasangan: json['pekerjaanpasangan'],
        namaperusahaanpasangan: json['namaperusahaanpasangan'],
        jabatanpasangan: json['jabatanpasangan'],
        ketjabatanpasangan: json['ketjabatanpasangan'],
        alamatusahapasangan: json['alamatusahapasangan'],
        kodeposperusahaanpasangan: json['kodeposperusahaanpasangan'],
        noteleponusahapasangan: json['noteleponusahapasangan'],
        masakerjapasangan: json['masakerjapasangan'],
        gajipasangan: json['gajipasangan'],
        slipgajipasangan: json['slipgajipasangan'],
        payrollpasangan: json['payrollpasangan'],
        bidangusahapasangan: json['bidangusahapasangan'],
        lamausahapasangan: json['lamausahapasangan'],
        omzetusahapasangan: json['omzetusahapasangan'],
        profitusahapasangan: json['profitusahapasangan'],
      );
}
