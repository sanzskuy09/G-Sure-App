// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pasangan_penjamin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPasanganPenjaminAdapter extends TypeAdapter<DataPasanganPenjamin> {
  @override
  final int typeId = 8;

  @override
  DataPasanganPenjamin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPasanganPenjamin(
      namapasanganpenjamin: fields[0] as String?,
      agamapasanganpenjamin: fields[1] as String?,
      warganegarapasanganpenjamin: fields[2] as String?,
      notelponpasanganpenjamin: fields[3] as String?,
      nowapasanganpenjamin: fields[4] as String?,
      pekerjaanpasanganpenjamin: fields[5] as String?,
      namaperusahaanpasanganpenjamin: fields[6] as String?,
      jabatanpasanganpenjamin: fields[7] as String?,
      ketjabatanpasanganpenjamin: fields[8] as String?,
      alamatperusahaanpasanganpenjamin: fields[9] as String?,
      kodeposperusahaanpasanganpenjamin: fields[10] as String?,
      noteleponusahapasanganpenjamin: fields[11] as String?,
      masakerjapasanganpenjamin: fields[12] as String?,
      gajipasanganpenjamin: fields[13] as String?,
      slipgajipasanganpenjamin: fields[14] as String?,
      payrollpasanganpenjamin: fields[15] as String?,
      bidangusahapasanganpenjamin: fields[16] as String?,
      lamausahapasanganpenjamin: fields[17] as String?,
      omzetusahapasanganpenjamin: fields[18] as String?,
      profitusahapasanganpenjamin: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPasanganPenjamin obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.namapasanganpenjamin)
      ..writeByte(1)
      ..write(obj.agamapasanganpenjamin)
      ..writeByte(2)
      ..write(obj.warganegarapasanganpenjamin)
      ..writeByte(3)
      ..write(obj.notelponpasanganpenjamin)
      ..writeByte(4)
      ..write(obj.nowapasanganpenjamin)
      ..writeByte(5)
      ..write(obj.pekerjaanpasanganpenjamin)
      ..writeByte(6)
      ..write(obj.namaperusahaanpasanganpenjamin)
      ..writeByte(7)
      ..write(obj.jabatanpasanganpenjamin)
      ..writeByte(8)
      ..write(obj.ketjabatanpasanganpenjamin)
      ..writeByte(9)
      ..write(obj.alamatperusahaanpasanganpenjamin)
      ..writeByte(10)
      ..write(obj.kodeposperusahaanpasanganpenjamin)
      ..writeByte(11)
      ..write(obj.noteleponusahapasanganpenjamin)
      ..writeByte(12)
      ..write(obj.masakerjapasanganpenjamin)
      ..writeByte(13)
      ..write(obj.gajipasanganpenjamin)
      ..writeByte(14)
      ..write(obj.slipgajipasanganpenjamin)
      ..writeByte(15)
      ..write(obj.payrollpasanganpenjamin)
      ..writeByte(16)
      ..write(obj.bidangusahapasanganpenjamin)
      ..writeByte(17)
      ..write(obj.lamausahapasanganpenjamin)
      ..writeByte(18)
      ..write(obj.omzetusahapasanganpenjamin)
      ..writeByte(19)
      ..write(obj.profitusahapasanganpenjamin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPasanganPenjaminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
