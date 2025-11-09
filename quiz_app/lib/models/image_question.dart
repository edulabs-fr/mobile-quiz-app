import 'package:hive/hive.dart';

part 'image_question.g.dart';

/// Modèle pour une image associée à une question
/// Supporte les images locales (assets) et distantes (URLs HTTP/HTTPS)
@HiveType(typeId: 4)
class QuestionImage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label; // Ex: "Architecture réseau", "Schéma TCP/IP"

  @HiveField(2)
  final String source; // URL distante (http/https) ou chemin local (assets/...)

  @HiveField(3)
  final String? description; // Description pour l'accessibilité

  @HiveField(4)
  final String sourceType; // "local" ou "remote" (déterminé automatiquement)

  QuestionImage({
    required this.id,
    required this.label,
    required this.source,
    this.description,
    String? sourceType,
  }) : sourceType = sourceType ?? _detectSourceType(source);

  /// Détecter automatiquement le type de source
  static String _detectSourceType(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return 'remote';
    }
    return 'local';
  }

  /// Vérifier si l'image est locale
  bool get isLocal => sourceType == 'local';

  /// Vérifier si l'image est distante
  bool get isRemote => sourceType == 'remote';

  /// Créer une QuestionImage depuis un Map YAML
  factory QuestionImage.fromYaml(Map<dynamic, dynamic> yaml) {
    final source = yaml['source'] as String? ?? yaml['asset_path'] as String;
    return QuestionImage(
      id: yaml['id'] as String,
      label: yaml['label'] as String,
      source: source,
      description: yaml['description'] as String?,
    );
  }

  /// Convertir en Map pour JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'source': source,
      'source_type': sourceType,
      'description': description,
    };
  }

  /// Copier avec modifications
  QuestionImage copyWith({
    String? id,
    String? label,
    String? source,
    String? description,
    String? sourceType,
  }) {
    return QuestionImage(
      id: id ?? this.id,
      label: label ?? this.label,
      source: source ?? this.source,
      description: description ?? this.description,
      sourceType: sourceType ?? this.sourceType,
    );
  }
}

/// Question avec images intégrées
@HiveType(typeId: 5)
class ImageQuestion {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<QuestionImage> images; // 1 à N images

  @HiveField(3)
  final List<String> options;

  @HiveField(4)
  final List<String> correctAnswers;

  @HiveField(5)
  final String explanation;

  @HiveField(6)
  final String? hint;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final String difficulty; // facile, moyen, difficile

  @HiveField(9)
  final List<String>? tags;

  @HiveField(10)
  final String? reference;

  @HiveField(11)
  final int points;

  ImageQuestion({
    required this.id,
    required this.question,
    required this.images,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
    this.hint,
    required this.category,
    required this.difficulty,
    this.tags,
    this.reference,
    this.points = 1,
  });

  /// Créer une ImageQuestion depuis un Map YAML
  factory ImageQuestion.fromYaml(Map<dynamic, dynamic> yaml) {
    final imagesList = (yaml['images'] as List?)?.map((img) {
      return QuestionImage.fromYaml(img as Map);
    }).toList() ?? [];

    return ImageQuestion(
      id: yaml['id'] as String,
      question: yaml['question'] as String,
      images: imagesList,
      options: List<String>.from(yaml['options'] as List),
      correctAnswers: List<String>.from(yaml['correct_answers'] as List),
      explanation: yaml['explanation'] as String,
      hint: yaml['hint'] as String?,
      category: yaml['category'] as String,
      difficulty: yaml['difficulty'] as String? ?? 'moyen',
      tags: yaml['tags'] != null ? List<String>.from(yaml['tags'] as List) : null,
      reference: yaml['reference'] as String?,
      points: yaml['points'] as int? ?? 1,
    );
  }

  /// Convertir en Map pour JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'images': images.map((img) => img.toJson()).toList(),
      'options': options,
      'correct_answers': correctAnswers,
      'explanation': explanation,
      'hint': hint,
      'category': category,
      'difficulty': difficulty,
      'tags': tags,
      'reference': reference,
      'points': points,
    };
  }

  /// Copier avec modifications
  ImageQuestion copyWith({
    String? id,
    String? question,
    List<QuestionImage>? images,
    List<String>? options,
    List<String>? correctAnswers,
    String? explanation,
    String? hint,
    String? category,
    String? difficulty,
    List<String>? tags,
    String? reference,
    int? points,
  }) {
    return ImageQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      images: images ?? this.images,
      options: options ?? this.options,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      reference: reference ?? this.reference,
      points: points ?? this.points,
    );
  }
}
