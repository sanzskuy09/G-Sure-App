// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pekerjaan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPekerjaanAdapter extends TypeAdapter<DataPekerjaan> {
  @override
  final int typeId = 100;

  @override
  DataPekerjaan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPekerjaan(
      jenispekerjaan: fields[0] as String?,
      namaperusahaan: fields[1] as String?,
      jabatan: fields[2] as String?,
      ketjabatan: fields[3] as String?,
      alamatusaha: fields[4] as String?,
      kodeposusaha: fields[5] as String?,
      noteleponusaha: fields[6] as String?,
      masakerjapemohon: fields[7] as String?,
      gajipemohon: fields[8] as String?,
      slipgajipemohon: fields[9] as String?,
      payrollpemohon: fields[10] as String?,
      bidangusahapemohon: fields[11] as String?,
      lamausahapemohon: fields[12] as String?,
      omzetusahapemohon: fields[13] as String?,
      profitusahapemohon: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPekerjaan obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.jenispekerjaan)
      ..writeByte(1)
      ..write(obj.namaperusahaan)
      ..writeByte(2)
      ..write(obj.jabatan)
      ..writeByte(3)
      ..write(obj.ketjabatan)
      ..writeByte(4)
      ..write(obj.alamatusaha)
      ..writeByte(5)
      ..write(obj.kodeposusaha)
      ..writeByte(6)
      ..write(obj.noteleponusaha)
      ..writeByte(7)
      ..write(obj.masakerjapemohon)
      ..writeByte(8)
      ..write(obj.gajipemohon)
      ..writeByte(9)
      ..write(obj.slipgajipemohon)
      ..writeByte(10)
      ..write(obj.payrollpemohon)
      ..writeByte(11)
      ..write(obj.bidangusahapemohon)
      ..writeByte(12)
      ..write(obj.lamausahapemohon)
      ..writeByte(13)
      ..write(obj.omzetusahapemohon)
      ..writeByte(14)
      ..write(obj.profitusahapemohon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPekerjaanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
