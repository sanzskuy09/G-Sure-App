import 'package:hive/hive.dart';

part 'data_alamat_survey_model.g.dart';

@HiveType(typeId: 3)
class DataAlamatSurvey extends HiveObject {
  @HiveField(0)
  String? alamatsurvey;
  @HiveField(1)
  String? rtsurvey;
  @HiveField(2)
  String? rwsurvey;
  @HiveField(3)
  String? kodepoksurvey;
  @HiveField(4)
  String? kelsurvey;
  @HiveField(5)
  String? kecsurvey;
  @HiveField(6)
  String? kotasurvey;
  @HiveField(7)
  String? provinsisurvey;

  DataAlamatSurvey({
    this.alamatsurvey,
    this.rtsurvey,
    this.rwsurvey,
    this.kodepoksurvey,
    this.kelsurvey,
    this.kecsurvey,
    this.kotasurvey,
    this.provinsisurvey,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'alamatsurvey': alamatsurvey,
        'rtsurvey': rtsurvey,
        'rwsurvey': rwsurvey,
        'kodepoksurvey': kodepoksurvey,
        'kelsurvey': kelsurvey,
        'kecsurvey': kecsurvey,
        'kotasurvey': kotasurvey,
        'provinsisurvey': provinsisurvey,
      };

  factory DataAlamatSurvey.fromJson(Map<String, dynamic> json) =>
      DataAlamatSurvey(
        alamatsurvey: json['alamatsurvey'],
        rtsurvey: json['rtsurvey'],
        rwsurvey: json['rwsurvey'],
        kodepoksurvey: json['kodepoksurvey'],
        kelsurvey: json['kelsurvey'],
        kecsurvey: json['kecsurvey'],
        kotasurvey: json['kotasurvey'],
        provinsisurvey: json['provinsisurvey'],
      );
}
