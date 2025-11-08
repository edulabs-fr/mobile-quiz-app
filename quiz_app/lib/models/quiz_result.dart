import 'package:hive/hive.dart';

part 'quiz_result.g.dart';

/// Modèle pour les résultats d'un quiz
@HiveType(typeId: 2)
class QuizResult {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int questionsTotal;

  @HiveField(4)
  final int correct;

  @HiveField(5)
  final int incorrect;

  @HiveField(6)
  final double averageTimePerQuestion;

  QuizResult({
    required this.id,
    required this.date,
    required this.category,
    required this.questionsTotal,
    required this.correct,
    required this.incorrect,
    required this.averageTimePerQuestion,
  });

  /// Calculer le score en pourcentage
  double get scorePercentage {
    if (questionsTotal == 0) return 0.0;
    return (correct / questionsTotal) * 100;
  }

  /// Générer un ID unique basé sur la date
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Copier avec modifications
  QuizResult copyWith({
    String? id,
    DateTime? date,
    String? category,
    int? questionsTotal,
    int? correct,
    int? incorrect,
    double? averageTimePerQuestion,
  }) {
    return QuizResult(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      questionsTotal: questionsTotal ?? this.questionsTotal,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      averageTimePerQuestion: averageTimePerQuestion ?? this.averageTimePerQuestion,
    );
  }

  /// Convertir en Map pour le stockage JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'category': category,
      'questions_total': questionsTotal,
      'correct': correct,
      'incorrect': incorrect,
      'average_time_per_question': averageTimePerQuestion,
    };
  }

  /// Créer depuis un Map JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
      questionsTotal: json['questions_total'] as int,
      correct: json['correct'] as int,
      incorrect: json['incorrect'] as int,
      averageTimePerQuestion: (json['average_time_per_question'] as num).toDouble(),
    );
  }
}
