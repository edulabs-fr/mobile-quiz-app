import 'package:hive/hive.dart';

part 'failed_question.g.dart';

/// Modèle pour tracer les questions échouées
@HiveType(typeId: 3)
class FailedQuestion {
  @HiveField(0)
  final String id; // ID unique de l'enregistrement d'erreur

  @HiveField(1)
  final String questionId; // ID de la question

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String difficulty;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final int failureCount; // Nombre de fois échouée

  @HiveField(6)
  final String question; // Texte de la question

  @HiveField(7)
  final List<String> correctAnswers; // Bonnes réponses

  FailedQuestion({
    required this.id,
    required this.questionId,
    required this.category,
    required this.difficulty,
    required this.date,
    this.failureCount = 1,
    required this.question,
    required this.correctAnswers,
  });

  /// Générer un ID unique
  static String generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
  }

  /// Copier avec modifications
  FailedQuestion copyWith({
    String? id,
    String? questionId,
    String? category,
    String? difficulty,
    DateTime? date,
    int? failureCount,
    String? question,
    List<String>? correctAnswers,
  }) {
    return FailedQuestion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      date: date ?? this.date,
      failureCount: failureCount ?? this.failureCount,
      question: question ?? this.question,
      correctAnswers: correctAnswers ?? this.correctAnswers,
    );
  }
}
