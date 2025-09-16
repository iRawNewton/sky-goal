// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 3;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as int?,
      amount: fields[1] as double,
      category: fields[2] as String,
      description: fields[3] as String,
      wallet: fields[4] as String,
      attachmentPath: fields[5] as String?,
      type: fields[6] as String,
      date: fields[7] as DateTime,
      walletId: fields[8] as int,
      createdAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.wallet)
      ..writeByte(5)
      ..write(obj.attachmentPath)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.walletId)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
