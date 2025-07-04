// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_kontak_darurat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataKontakDaruratAdapter extends TypeAdapter<DataKontakDarurat> {
  @override
  final int typeId = 6;

  @override
  DataKontakDarurat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataKontakDarurat(
      namakontak: fields[0] as String?,
      jeniskelaminkontak: fields[1] as String?,
      hubungankeluarga: fields[2] as String?,
      nohpkontak: fields[3] as String?,
      alamatkontak: fields[4] as String?,
      kodeposkontak: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataKontakDarurat obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.namakontak)
      ..writeByte(1)
      ..write(obj.jeniskelaminkontak)
      ..writeByte(2)
      ..write(obj.hubungankeluarga)
      ..writeByte(3)
      ..write(obj.nohpkontak)
      ..writeByte(4)
      ..write(obj.alamatkontak)
      ..writeByte(5)
      ..write(obj.kodeposkontak);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataKontakDaruratAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
