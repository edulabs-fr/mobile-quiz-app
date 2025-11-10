// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizResultAdapter extends TypeAdapter<QuizResult> {
  @override
  final int typeId = 2;

  @override
  QuizResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizResult(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      category: fields[2] as String,
      questionsTotal: fields[3] as int,
      correct: fields[4] as int,
      incorrect: fields[5] as int,
      averageTimePerQuestion: fields[6] as double,
      difficultyStats: (fields[7] as Map).cast<String, dynamic>(),
      difficultiesPresentes: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizResult obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.questionsTotal)
      ..writeByte(4)
      ..write(obj.correct)
      ..writeByte(5)
      ..write(obj.incorrect)
      ..writeByte(6)
      ..write(obj.averageTimePerQuestion)
      ..writeByte(7)
      ..write(obj.difficultyStats)
      ..writeByte(8)
      ..write(obj.difficultiesPresentes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
