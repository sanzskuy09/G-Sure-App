import 'package:gsure/models/data_pekerjaan_penjamin_model.dart';
import 'package:hive/hive.dart';

part 'data_penjamin_model.g.dart';

@HiveType(typeId: 7)
class DataPenjamin extends HiveObject {
  @HiveField(0)
  String? jnspenjamin;
  @HiveField(1)
  String? statuspernikahanpenjamin;
  @HiveField(2)
  String? namapenjamin;
  @HiveField(3)
  String? agamapenjamin;
  @HiveField(4)
  String? warganegarapenjamin;
  @HiveField(5)
  String? notelppenjamin;
  @HiveField(6)
  String? nowapenjamin;
  @HiveField(7)
  String? ktppenjamin;
  @HiveField(8)
  String? tglktppenjamin;
  @HiveField(9)
  String? simpenjamin;
  @HiveField(10)
  String? npwppenjamin;
  @HiveField(11)
  String? alamatpenjamin;
  @HiveField(12)
  String? kotapenjamin;
  @HiveField(13)
  String? namaibupenjamin;
  @HiveField(14)
  String? statusrumahpenjamin;
  @HiveField(15)
  String? lokasirumahpenjamin;
  @HiveField(16)
  String? katrumahpenjamin;
  @HiveField(17)
  String? buktimilikrumahpenjamin;
  @HiveField(18)
  String? lamatinggalpenjamin;
  @HiveField(19)
  DataPekerjaanPenjamin? dataPekerjaanPenjamin;

  DataPenjamin({
    this.jnspenjamin,
    this.statuspernikahanpenjamin,
    this.namapenjamin,
    this.agamapenjamin,
    this.warganegarapenjamin,
    this.notelppenjamin,
    this.nowapenjamin,
    this.ktppenjamin,
    this.tglktppenjamin,
    this.simpenjamin,
    this.npwppenjamin,
    this.alamatpenjamin,
    this.kotapenjamin,
    this.namaibupenjamin,
    this.statusrumahpenjamin,
    this.lokasirumahpenjamin,
    this.katrumahpenjamin,
    this.buktimilikrumahpenjamin,
    this.lamatinggalpenjamin,
    this.dataPekerjaanPenjamin,
  });

  // Method untuk API
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = {
      'jnspenjamin': jnspenjamin,
      'statuspernikahanpenjamin': statuspernikahanpenjamin,
      'namapenjamin': namapenjamin,
      'agamapenjamin': agamapenjamin,
      'warganegarapenjamin': warganegarapenjamin,
      'notelppenjamin': notelppenjamin,
      'nowapenjamin': nowapenjamin,
      'ktppenjamin': ktppenjamin,
      'tglktppenjamin': tglktppenjamin,
      'simpenjamin': simpenjamin,
      'npwppenjamin': npwppenjamin,
      'alamatpenjamin': alamatpenjamin,
      'kotapenjamin': kotapenjamin,
      'namaibupenjamin': namaibupenjamin,
      'statusrumahpenjamin': statusrumahpenjamin,
      'lokasirumahpenjamin': lokasirumahpenjamin,
      'katrumahpenjamin': katrumahpenjamin,
      'buktimilikrumahpenjamin': buktimilikrumahpenjamin,
      'lamatinggalpenjamin': lamatinggalpenjamin,
    };

    if (dataPekerjaanPenjamin != null) {
      jsonMap.addAll(dataPekerjaanPenjamin!.toJson());
    }

    return jsonMap;
  }

  factory DataPenjamin.fromJson(Map<String, dynamic> json) => DataPenjamin(
        jnspenjamin: json['jnspenjamin'],
        statuspernikahanpenjamin: json['statuspernikahanpenjamin'],
        namapenjamin: json['namapenjamin'],
        agamapenjamin: json['agamapenjamin'],
        warganegarapenjamin: json['warganegarapenjamin'],
        notelppenjamin: json['notelppenjamin'],
        nowapenjamin: json['nowapenjamin'],
        ktppenjamin: json['ktppenjamin'],
        tglktppenjamin: json['tglktppenjamin'],
        simpenjamin: json['simpenjamin'],
        npwppenjamin: json['npwppenjamin'],
        alamatpenjamin: json['alamatpenjamin'],
        kotapenjamin: json['kotapenjamin'],
        namaibupenjamin: json['namaibupenjamin'],
        statusrumahpenjamin: json['statusrumahpenjamin'],
        lokasirumahpenjamin: json['lokasirumahpenjamin'],
        katrumahpenjamin: json['katrumahpenjamin'],
        buktimilikrumahpenjamin: json['buktimilikrumahpenjamin'],
        lamatinggalpenjamin: json['lamatinggalpenjamin'],
        dataPekerjaanPenjamin: json['dataPekerjaanPenjamin'] != null
            ? DataPekerjaanPenjamin.fromJson(json['dataPekerjaanPenjamin'])
            : null,
      );
}
