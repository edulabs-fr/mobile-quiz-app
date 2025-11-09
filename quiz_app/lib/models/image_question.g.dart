// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionImageAdapter extends TypeAdapter<QuestionImage> {
  @override
  final int typeId = 4;

  @override
  QuestionImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionImage(
      id: fields[0] as String,
      label: fields[1] as String,
      source: fields[2] as String,
      description: fields[3] as String?,
      sourceType: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionImage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.sourceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageQuestionAdapter extends TypeAdapter<ImageQuestion> {
  @override
  final int typeId = 5;

  @override
  ImageQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageQuestion(
      id: fields[0] as String,
      question: fields[1] as String,
      images: (fields[2] as List).cast<QuestionImage>(),
      options: (fields[3] as List).cast<String>(),
      correctAnswers: (fields[4] as List).cast<String>(),
      explanation: fields[5] as String,
      hint: fields[6] as String?,
      category: fields[7] as String,
      difficulty: fields[8] as String,
      tags: (fields[9] as List?)?.cast<String>(),
      reference: fields[10] as String?,
      points: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ImageQuestion obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.options)
      ..writeByte(4)
      ..write(obj.correctAnswers)
      ..writeByte(5)
      ..write(obj.explanation)
      ..writeByte(6)
      ..write(obj.hint)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.reference)
      ..writeByte(11)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
