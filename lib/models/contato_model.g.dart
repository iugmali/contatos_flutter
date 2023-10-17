// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contato_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContatoModelAdapter extends TypeAdapter<ContatoModel> {
  @override
  final int typeId = 1;

  @override
  ContatoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContatoModel(
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContatoModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.imgPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContatoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
