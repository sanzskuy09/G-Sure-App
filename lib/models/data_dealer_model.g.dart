// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_dealer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataDealerAdapter extends TypeAdapter<DataDealer> {
  @override
  final int typeId = 1;

  @override
  DataDealer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataDealer(
      kddealer: fields[0] as String?,
      namadealer: fields[1] as String?,
      alamatdealer: fields[2] as String?,
      rtdealer: fields[3] as String?,
      rwdealer: fields[4] as String?,
      kodeposdealer: fields[5] as String?,
      keldealer: fields[6] as String?,
      kecdealer: fields[7] as String?,
      kotadealer: fields[8] as String?,
      provinsidealer: fields[9] as String?,
      telpondealer: fields[10] as String?,
      namapemilikdealer: fields[11] as String?,
      nohppemilik: fields[12] as String?,
      picdealer: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataDealer obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.kddealer)
      ..writeByte(1)
      ..write(obj.namadealer)
      ..writeByte(2)
      ..write(obj.alamatdealer)
      ..writeByte(3)
      ..write(obj.rtdealer)
      ..writeByte(4)
      ..write(obj.rwdealer)
      ..writeByte(5)
      ..write(obj.kodeposdealer)
      ..writeByte(6)
      ..write(obj.keldealer)
      ..writeByte(7)
      ..write(obj.kecdealer)
      ..writeByte(8)
      ..write(obj.kotadealer)
      ..writeByte(9)
      ..write(obj.provinsidealer)
      ..writeByte(10)
      ..write(obj.telpondealer)
      ..writeByte(11)
      ..write(obj.namapemilikdealer)
      ..writeByte(12)
      ..write(obj.nohppemilik)
      ..writeByte(13)
      ..write(obj.picdealer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataDealerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
