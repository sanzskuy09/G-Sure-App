import 'package:gsure/models/data_pekerjaan_model.dart';
import 'package:hive/hive.dart';

part 'data_pemohon_model.g.dart';

@HiveType(typeId: 4)
class DataPemohon extends HiveObject {
  @HiveField(0)
  String? katpemohon;
  @HiveField(1)
  String? statuspernikahan;
  @HiveField(2)
  String? nama;
  @HiveField(3)
  String? agamapemohon;
  @HiveField(4)
  String? pendidikan;
  @HiveField(5)
  String? warganegarapemohon;
  @HiveField(6)
  String? nomortelepon;
  @HiveField(7)
  String? nohp;
  @HiveField(8)
  String? email;
  @HiveField(9)
  String? sim;
  @HiveField(10)
  String? npwp;
  @HiveField(11)
  String? namaibu;
  @HiveField(12)
  String? statusrumah;
  @HiveField(13)
  String? lokasirumah;
  @HiveField(14)
  String? katrumahpemohon;
  @HiveField(15)
  String? buktimilikrumahpemohon;
  @HiveField(16)
  String? lamatinggalpemohon;
  @HiveField(17)
  DataPekerjaan? dataPekerjaan;

  DataPemohon({
    this.katpemohon,
    this.statuspernikahan,
    this.nama,
    this.agamapemohon,
    this.pendidikan,
    this.warganegarapemohon,
    this.nomortelepon,
    this.nohp,
    this.email,
    this.sim,
    this.npwp,
    this.namaibu,
    this.statusrumah,
    this.lokasirumah,
    this.katrumahpemohon,
    this.buktimilikrumahpemohon,
    this.lamatinggalpemohon,
    this.dataPekerjaan,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'katpemohon': katpemohon,
        'statuspernikahan': statuspernikahan,
        'nama': nama,
        'agamapemohon': agamapemohon,
        'pendidikan': pendidikan,
        'warganegarapemohon': warganegarapemohon,
        'nomortelepon': nomortelepon,
        'nohp': nohp,
        'email': email,
        'sim': sim,
        'npwp': npwp,
        'namaibu': namaibu,
        'statusrumah': statusrumah,
        'lokasirumah': lokasirumah,
        'katrumahpemohon': katrumahpemohon,
        'buktimilikrumahpemohon': buktimilikrumahpemohon,
        'lamatinggalpemohon': lamatinggalpemohon,
        'dataPekerjaan': dataPekerjaan?.toJson(),
      };

  factory DataPemohon.fromJson(Map<String, dynamic> json) => DataPemohon(
        katpemohon: json['katpemohon'],
        statuspernikahan: json['statuspernikahan'],
        nama: json['nama'],
        agamapemohon: json['agamapemohon'],
        pendidikan: json['pendidikan'],
        warganegarapemohon: json['warganegarapemohon'],
        nomortelepon: json['nomortelepon'],
        nohp: json['nohp'],
        email: json['email'],
        sim: json['sim'],
        npwp: json['npwp'],
        namaibu: json['namaibu'],
        statusrumah: json['statusrumah'],
        lokasirumah: json['lokasirumah'],
        katrumahpemohon: json['katrumahpemohon'],
        buktimilikrumahpemohon: json['buktimilikrumahpemohon'],
        lamatinggalpemohon: json['lamatinggalpemohon'],
        dataPekerjaan: json['dataPekerjaan'] != null
            ? DataPekerjaan.fromJson(json['dataPekerjaan'])
            : null,
      );
}
