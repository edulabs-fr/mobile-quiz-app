import 'package:hive/hive.dart';

part 'flashcard.g.dart';

/// Modèle pour une flashcard
@HiveType(typeId: 1)
class Flashcard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String term;

  @HiveField(2)
  final String explanation;

  @HiveField(3)
  final String? example;

  @HiveField(4)
  final String category;

  @HiveField(5)
  bool isMarked;

  Flashcard({
    required this.id,
    required this.term,
    required this.explanation,
    this.example,
    required this.category,
    this.isMarked = false,
  });

  /// Créer une Flashcard depuis un Map YAML
  factory Flashcard.fromYaml(Map<dynamic, dynamic> yaml) {
    return Flashcard(
      id: yaml['id'] as String,
      term: yaml['term'] as String,
      explanation: yaml['explanation'] as String,
      example: yaml['example'] as String?,
      category: yaml['category'] as String,
      isMarked: false,
    );
  }

  /// Copier avec modifications
  Flashcard copyWith({
    String? id,
    String? term,
    String? explanation,
    String? example,
    String? category,
    bool? isMarked,
  }) {
    return Flashcard(
      id: id ?? this.id,
      term: term ?? this.term,
      explanation: explanation ?? this.explanation,
      example: example ?? this.example,
      category: category ?? this.category,
      isMarked: isMarked ?? this.isMarked,
    );
  }
}
