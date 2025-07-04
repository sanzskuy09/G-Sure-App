// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pekerjaan_penjamin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPekerjaanPenjaminAdapter extends TypeAdapter<DataPekerjaanPenjamin> {
  @override
  final int typeId = 101;

  @override
  DataPekerjaanPenjamin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPekerjaanPenjamin(
      pekerjaanpenjamin: fields[0] as String?,
      namaperusahaanpenjamin: fields[1] as String?,
      jabatanpenjamin: fields[2] as String?,
      ketjabatanpenjamin: fields[3] as String?,
      alamatusahapenjamin: fields[4] as String?,
      kodeposperusahaanpenjamin: fields[5] as String?,
      noteleponusahapenjamin: fields[6] as String?,
      masakerjapenjamin: fields[7] as String?,
      gajipenjamin: fields[8] as Double?,
      slipgajipenjamin: fields[9] as String?,
      payrollpenjamin: fields[10] as String?,
      bidangusahapenjamin: fields[11] as String?,
      lamausahapenjamin: fields[12] as String?,
      omzetusahapenjamin: fields[13] as Double?,
      profitusahapenjamin: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPekerjaanPenjamin obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.pekerjaanpenjamin)
      ..writeByte(1)
      ..write(obj.namaperusahaanpenjamin)
      ..writeByte(2)
      ..write(obj.jabatanpenjamin)
      ..writeByte(3)
      ..write(obj.ketjabatanpenjamin)
      ..writeByte(4)
      ..write(obj.alamatusahapenjamin)
      ..writeByte(5)
      ..write(obj.kodeposperusahaanpenjamin)
      ..writeByte(6)
      ..write(obj.noteleponusahapenjamin)
      ..writeByte(7)
      ..write(obj.masakerjapenjamin)
      ..writeByte(8)
      ..write(obj.gajipenjamin)
      ..writeByte(9)
      ..write(obj.slipgajipenjamin)
      ..writeByte(10)
      ..write(obj.payrollpenjamin)
      ..writeByte(11)
      ..write(obj.bidangusahapenjamin)
      ..writeByte(12)
      ..write(obj.lamausahapenjamin)
      ..writeByte(13)
      ..write(obj.omzetusahapenjamin)
      ..writeByte(14)
      ..write(obj.profitusahapenjamin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPekerjaanPenjaminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
