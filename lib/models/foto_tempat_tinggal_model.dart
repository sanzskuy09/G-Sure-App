import 'package:hive/hive.dart';

part 'foto_tempat_tinggal_model.g.dart';

@HiveType(typeId: 11)
class FotoTempatTinggal extends HiveObject {
  @HiveField(0)
  String? fotorumah;
  @HiveField(1)
  String? fotorumahselfiecmo;
  @HiveField(2)
  String? fotolingkunganselfiecmo;
  @HiveField(3)
  String? fotobuktimilikrumah;
  @HiveField(4)
  String? fotocloseuppemohon;
  @HiveField(5)
  String? fotopemohonttdfpp;
  @HiveField(6)
  String? fotofppdepan;
  @HiveField(7)
  String? fotofppbelakang;

  FotoTempatTinggal({
    this.fotorumah,
    this.fotorumahselfiecmo,
    this.fotolingkunganselfiecmo,
    this.fotobuktimilikrumah,
    this.fotocloseuppemohon,
    this.fotopemohonttdfpp,
    this.fotofppdepan,
    this.fotofppbelakang,
  });

  // Method untuk API
  Map<String, dynamic> toJson() => {
        'fotorumah': fotorumah,
        'fotorumahselfiecmo': fotorumahselfiecmo,
        'fotolingkunganselfiecmo': fotolingkunganselfiecmo,
        'fotobuktimilikrumah': fotobuktimilikrumah,
        'fotocloseuppemohon': fotocloseuppemohon,
        'fotopemohonttdfpp': fotopemohonttdfpp,
        'fotofppdepan': fotofppdepan,
        'fotofppbelakang': fotofppbelakang,
      };

  factory FotoTempatTinggal.fromJson(Map<String, dynamic> json) =>
      FotoTempatTinggal(
        fotorumah: json['fotorumah'],
        fotorumahselfiecmo: json['fotorumahselfiecmo'],
        fotolingkunganselfiecmo: json['fotolingkunganselfiecmo'],
        fotobuktimilikrumah: json['fotobuktimilikrumah'],
        fotocloseuppemohon: json['fotocloseuppemohon'],
        fotopemohonttdfpp: json['fotopemohonttdfpp'],
        fotofppdepan: json['fotofppdepan'],
        fotofppbelakang: json['fotofppbelakang'],
      );
}
