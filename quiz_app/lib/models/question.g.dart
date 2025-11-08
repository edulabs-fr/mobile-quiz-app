// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 0;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      id: fields[0] as String,
      question: fields[1] as String,
      options: (fields[2] as List).cast<String>(),
      correctAnswers: (fields[3] as List).cast<String>(),
      explanation: fields[4] as String,
      hint: fields[5] as String?,
      category: fields[6] as String,
      difficulty: fields[7] as String,
      isMarked: fields[8] as bool,
      questionType: fields[9] as String,
      points: fields[10] as int,
      tags: (fields[11] as List?)?.cast<String>(),
      reference: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.correctAnswers)
      ..writeByte(4)
      ..write(obj.explanation)
      ..writeByte(5)
      ..write(obj.hint)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.isMarked)
      ..writeByte(9)
      ..write(obj.questionType)
      ..writeByte(10)
      ..write(obj.points)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.reference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
