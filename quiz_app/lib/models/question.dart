import 'package:hive/hive.dart';

part 'question.g.dart';

/// Modèle pour une question de quiz
@HiveType(typeId: 0)
class Question {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final List<String> correctAnswers;

  @HiveField(4)
  final String explanation;

  @HiveField(5)
  final String? hint;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String difficulty;

  @HiveField(8)
  bool isMarked;

  @HiveField(9)
  final String questionType; // 'single' ou 'multiple'

  @HiveField(10)
  final int points; // Points pour cette question

  @HiveField(11)
  final List<String>? tags; // Tags pour catégoriser

  @HiveField(12)
  final String? reference; // Référence ou lien vers documentation

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
    this.hint,
    required this.category,
    required this.difficulty,
    this.isMarked = false,
    this.questionType = 'single', // Par défaut choix unique
    this.points = 1, // Par défaut 1 point
    this.tags,
    this.reference,
  });

  /// Créer une Question depuis un Map YAML
  factory Question.fromYaml(Map<dynamic, dynamic> yaml) {
    final correctAnswers = List<String>.from(yaml['correct_answers'] as List);
    
    // Déterminer automatiquement le type de question
    String questionType = yaml['question_type'] as String? ?? 
        (correctAnswers.length > 1 ? 'multiple' : 'single');
    
    return Question(
      id: yaml['id'] as String,
      question: yaml['question'] as String,
      options: List<String>.from(yaml['options'] as List),
      correctAnswers: correctAnswers,
      explanation: yaml['explanation'] as String,
      hint: yaml['hint'] as String?,
      category: yaml['category'] as String,
      difficulty: yaml['difficulty'] as String? ?? 'medium',
      isMarked: false,
      questionType: questionType,
      points: yaml['points'] as int? ?? 1,
      tags: yaml['tags'] != null ? List<String>.from(yaml['tags'] as List) : null,
      reference: yaml['reference'] as String?,
    );
  }

  /// Vérifier si c'est une question à choix multiple
  bool get isMultipleChoice => questionType == 'multiple' || correctAnswers.length > 1;

  /// Vérifier si une réponse est correcte
  bool isCorrectAnswer(String answer) {
    return correctAnswers.contains(answer);
  }

  /// Vérifier si plusieurs réponses sont correctes
  bool areCorrectAnswers(List<String> answers) {
    if (answers.length != correctAnswers.length) return false;
    return answers.every((answer) => correctAnswers.contains(answer));
  }

  /// Copier avec modifications
  Question copyWith({
    String? id,
    String? question,
    List<String>? options,
    List<String>? correctAnswers,
    String? explanation,
    String? hint,
    String? category,
    String? difficulty,
    bool? isMarked,
    String? questionType,
    int? points,
    List<String>? tags,
    String? reference,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      isMarked: isMarked ?? this.isMarked,
      questionType: questionType ?? this.questionType,
      points: points ?? this.points,
      tags: tags ?? this.tags,
      reference: reference ?? this.reference,
    );
  }
}
