// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foto_tempat_tinggal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FotoTempatTinggalAdapter extends TypeAdapter<FotoTempatTinggal> {
  @override
  final int typeId = 11;

  @override
  FotoTempatTinggal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FotoTempatTinggal(
      fotorumah: fields[0] as String?,
      fotorumahselfiecmo: fields[1] as String?,
      fotolingkunganselfiecmo: fields[2] as String?,
      fotobuktimilikrumah: fields[3] as String?,
      fotocloseuppemohon: fields[4] as String?,
      fotopemohonttdfpp: fields[5] as String?,
      fotofppdepan: fields[6] as String?,
      fotofppbelakang: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FotoTempatTinggal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.fotorumah)
      ..writeByte(1)
      ..write(obj.fotorumahselfiecmo)
      ..writeByte(2)
      ..write(obj.fotolingkunganselfiecmo)
      ..writeByte(3)
      ..write(obj.fotobuktimilikrumah)
      ..writeByte(4)
      ..write(obj.fotocloseuppemohon)
      ..writeByte(5)
      ..write(obj.fotopemohonttdfpp)
      ..writeByte(6)
      ..write(obj.fotofppdepan)
      ..writeByte(7)
      ..write(obj.fotofppbelakang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FotoTempatTinggalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
