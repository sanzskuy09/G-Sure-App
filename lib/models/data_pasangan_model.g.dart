// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pasangan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPasanganAdapter extends TypeAdapter<DataPasangan> {
  @override
  final int typeId = 5;

  @override
  DataPasangan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPasangan(
      namapasangan: fields[0] as String?,
      namapanggilan: fields[1] as String?,
      ktppasangan: fields[2] as String?,
      agamapasangan: fields[3] as String?,
      warganegarapasangan: fields[4] as String?,
      notelppasangan: fields[5] as String?,
      nohppasangan: fields[6] as String?,
      pekerjaanpasangan: fields[7] as String?,
      namaperusahaanpasangan: fields[8] as String?,
      jabatanpasangan: fields[9] as String?,
      ketjabatanpasangan: fields[10] as String?,
      alamatusahapasangan: fields[11] as String?,
      kodeposperusahaanpasangan: fields[12] as String?,
      noteleponusahapasangan: fields[13] as String?,
      masakerjapasangan: fields[14] as String?,
      gajipasangan: fields[15] as String?,
      slipgajipasangan: fields[16] as String?,
      payrollpasangan: fields[17] as String?,
      bidangusahapasangan: fields[18] as String?,
      lamausahapasangan: fields[19] as String?,
      omzetusahapasangan: fields[20] as String?,
      profitusahapasangan: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPasangan obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.namapasangan)
      ..writeByte(1)
      ..write(obj.namapanggilan)
      ..writeByte(2)
      ..write(obj.ktppasangan)
      ..writeByte(3)
      ..write(obj.agamapasangan)
      ..writeByte(4)
      ..write(obj.warganegarapasangan)
      ..writeByte(5)
      ..write(obj.notelppasangan)
      ..writeByte(6)
      ..write(obj.nohppasangan)
      ..writeByte(7)
      ..write(obj.pekerjaanpasangan)
      ..writeByte(8)
      ..write(obj.namaperusahaanpasangan)
      ..writeByte(9)
      ..write(obj.jabatanpasangan)
      ..writeByte(10)
      ..write(obj.ketjabatanpasangan)
      ..writeByte(11)
      ..write(obj.alamatusahapasangan)
      ..writeByte(12)
      ..write(obj.kodeposperusahaanpasangan)
      ..writeByte(13)
      ..write(obj.noteleponusahapasangan)
      ..writeByte(14)
      ..write(obj.masakerjapasangan)
      ..writeByte(15)
      ..write(obj.gajipasangan)
      ..writeByte(16)
      ..write(obj.slipgajipasangan)
      ..writeByte(17)
      ..write(obj.payrollpasangan)
      ..writeByte(18)
      ..write(obj.bidangusahapasangan)
      ..writeByte(19)
      ..write(obj.lamausahapasangan)
      ..writeByte(20)
      ..write(obj.omzetusahapasangan)
      ..writeByte(21)
      ..write(obj.profitusahapasangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPasanganAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
