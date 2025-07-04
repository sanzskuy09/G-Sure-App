import 'package:hive/hive.dart';

part 'data_dealer_model.g.dart';

@HiveType(typeId: 1)
class DataDealer extends HiveObject {
  @HiveField(0)
  String? kddealer;
  @HiveField(1)
  String? namadealer;
  @HiveField(2)
  String? alamatdealer;
  @HiveField(3)
  String? rtdealer;
  @HiveField(4)
  String? rwdealer;
  @HiveField(5)
  String? kodeposdealer;
  @HiveField(6)
  String? keldealer;
  @HiveField(7)
  String? kecdealer;
  @HiveField(8)
  String? kotadealer;
  @HiveField(9)
  String? provinsidealer;
  @HiveField(10)
  String? telpondealer;
  @HiveField(11)
  String? namapemilikdealer;
  @HiveField(12)
  String? nohppemilik;
  @HiveField(13)
  String? picdealer;

  DataDealer({
    this.kddealer,
    this.namadealer,
    this.alamatdealer,
    this.rtdealer,
    this.rwdealer,
    this.kodeposdealer,
    this.keldealer,
    this.kecdealer,
    this.kotadealer,
    this.provinsidealer,
    this.telpondealer,
    this.namapemilikdealer,
    this.nohppemilik,
    this.picdealer,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'kddealer': kddealer,
        'namadealer': namadealer,
        'alamatdealer': alamatdealer,
        'rtdealer': rtdealer,
        'rwdealer': rwdealer,
        'kodeposdealer': kodeposdealer,
        'keldealer': keldealer,
        'kecdealer': kecdealer,
        'kotadealer': kotadealer,
        'provinsidealer': provinsidealer,
        'telpondealer': telpondealer,
        'namapemilikdealer': namapemilikdealer,
        'nohppemilik': nohppemilik,
        'picdealer': picdealer,
      };

  factory DataDealer.fromJson(Map<String, dynamic> json) => DataDealer(
        kddealer: json['kddealer'],
        namadealer: json['namadealer'],
        alamatdealer: json['alamatdealer'],
        rtdealer: json['rtdealer'],
        rwdealer: json['rwdealer'],
        kodeposdealer: json['kodeposdealer'],
        keldealer: json['keldealer'],
        kecdealer: json['kecdealer'],
        kotadealer: json['kotadealer'],
        provinsidealer: json['provinsidealer'],
        telpondealer: json['telpondealer'],
        namapemilikdealer: json['namapemilikdealer'],
        nohppemilik: json['nohppemilik'],
        picdealer: json['picdealer'],
      );
}
