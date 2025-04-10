// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItineraryPlanAdapter extends TypeAdapter<ItineraryPlan> {
  @override
  final int typeId = 1;

  @override
  ItineraryPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryPlan(
      id: fields[0] as String,
      title: fields[1] as String,
      day: fields[2] as String,
      time: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
