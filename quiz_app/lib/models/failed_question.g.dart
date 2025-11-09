// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FailedQuestionAdapter extends TypeAdapter<FailedQuestion> {
  @override
  final int typeId = 3;

  @override
  FailedQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FailedQuestion(
      id: fields[0] as String,
      questionId: fields[1] as String,
      category: fields[2] as String,
      difficulty: fields[3] as String,
      date: fields[4] as DateTime,
      failureCount: fields[5] as int,
      question: fields[6] as String,
      correctAnswers: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FailedQuestion obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionId)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.failureCount)
      ..writeByte(6)
      ..write(obj.question)
      ..writeByte(7)
      ..write(obj.correctAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
