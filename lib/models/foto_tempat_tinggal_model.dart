import 'package:gsure/models/photo_data_model.dart';
import 'package:hive/hive.dart';

part 'foto_tempat_tinggal_model.g.dart';

@HiveType(typeId: 11)
class FotoTempatTinggal extends HiveObject {
  @HiveField(0)
  PhotoData? fotorumah;
  @HiveField(1)
  PhotoData? fotorumahselfiecmo;
  @HiveField(2)
  PhotoData? fotolingkunganselfiecmo;
  @HiveField(3)
  PhotoData? fotobuktimilikrumah;
  @HiveField(4)
  PhotoData? fotocloseuppemohon;
  @HiveField(5)
  PhotoData? fotopemohonttdfpp;
  @HiveField(6)
  PhotoData? fotofppdepan;
  @HiveField(7)
  PhotoData? fotofppbelakang;

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

  // factory FotoTempatTinggal.fromJson(Map<String, dynamic> json) =>
  //     FotoTempatTinggal(
  //       fotorumah: json['fotorumah'],
  //       fotorumahselfiecmo: json['fotorumahselfiecmo'],
  //       fotolingkunganselfiecmo: json['fotolingkunganselfiecmo'],
  //       fotobuktimilikrumah: json['fotobuktimilikrumah'],
  //       fotocloseuppemohon: json['fotocloseuppemohon'],
  //       fotopemohonttdfpp: json['fotopemohonttdfpp'],
  //       fotofppdepan: json['fotofppdepan'],
  //       fotofppbelakang: json['fotofppbelakang'],
  //     );

  // Perbarui juga factory fromJson-nya
  factory FotoTempatTinggal.fromJson(Map<String, dynamic> json) {
    return FotoTempatTinggal(
      fotorumah: json['fotorumah'] != null
          ? PhotoData.fromJson(json['fotorumah'])
          : null,
      fotorumahselfiecmo: json['fotorumahselfiecmo'] != null
          ? PhotoData.fromJson(json['fotorumahselfiecmo'])
          : null,
      fotolingkunganselfiecmo: json['fotolingkunganselfiecmo'] != null
          ? PhotoData.fromJson(json['fotolingkunganselfiecmo'])
          : null,
      fotobuktimilikrumah: json['fotobuktimilikrumah'] != null
          ? PhotoData.fromJson(json['fotobuktimilikrumah'])
          : null,
      fotocloseuppemohon: json['fotocloseuppemohon'] != null
          ? PhotoData.fromJson(json['fotocloseuppemohon'])
          : null,
      fotopemohonttdfpp: json['fotopemohonttdfpp'] != null
          ? PhotoData.fromJson(json['fotopemohonttdfpp'])
          : null,
      fotofppdepan: json['fotofppdepan'] != null
          ? PhotoData.fromJson(json['fotofppdepan'])
          : null,
      fotofppbelakang: json['fotofppbelakang'] != null
          ? PhotoData.fromJson(json['fotofppbelakang'])
          : null,
    );
  }
}
