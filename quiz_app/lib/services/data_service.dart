import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../models/question.dart';
import '../models/flashcard.dart';

/// Service pour charger et parser les fichiers YAML
class DataService {
  // Cache pour éviter de recharger les données
  static final Map<String, List<Question>> _questionsCache = {};
  static final Map<String, List<Flashcard>> _flashcardsCache = {};

  /// Charger toutes les questions d'une catégorie
  static Future<List<Question>> loadQuestions(String category) async {
    // Vérifier le cache d'abord
    if (_questionsCache.containsKey(category)) {
      return _questionsCache[category]!;
    }

    try {
      // Charger le fichier YAML depuis les assets
      final yamlString = await rootBundle.loadString(
        'assets/data/$category/questions.yaml',
      );

      // Parser le YAML
      final dynamic yamlData = loadYaml(yamlString);

      // Convertir en liste de Questions
      final List<Question> questions = [];
      if (yamlData is List) {
        for (var item in yamlData) {
          try {
            questions.add(Question.fromYaml(item as Map));
          } catch (e) {
            print('Erreur lors du parsing de la question: $e');
          }
        }
      }

      // Mettre en cache
      _questionsCache[category] = questions;

      return questions;
    } catch (e) {
      print('Erreur lors du chargement des questions pour $category: $e');
      return [];
    }
  }

  /// Charger toutes les flashcards d'une catégorie
  static Future<List<Flashcard>> loadFlashcards(String category) async {
    // Vérifier le cache d'abord
    if (_flashcardsCache.containsKey(category)) {
      return _flashcardsCache[category]!;
    }

    try {
      // Charger le fichier YAML depuis les assets
      final yamlString = await rootBundle.loadString(
        'assets/data/$category/flashcards.yaml',
      );

      // Parser le YAML
      final dynamic yamlData = loadYaml(yamlString);

      // Convertir en liste de Flashcards
      final List<Flashcard> flashcards = [];
      if (yamlData is List) {
        for (var item in yamlData) {
          try {
            flashcards.add(Flashcard.fromYaml(item as Map));
          } catch (e) {
            print('Erreur lors du parsing de la flashcard: $e');
          }
        }
      }

      // Mettre en cache
      _flashcardsCache[category] = flashcards;

      return flashcards;
    } catch (e) {
      print('Erreur lors du chargement des flashcards pour $category: $e');
      return [];
    }
  }

  /// Obtenir la liste des catégories disponibles
  static Future<List<String>> getAvailableCategories() async {
    // Pour le MVP, nous retournons uniquement les catégories qui ont des fichiers
    final List<String> allCategories = [
      'user_management',
      'filesystem',
      'service',
      'Réseaux',
    ];
    
    // Filtrer pour ne garder que celles qui ont des questions
    final List<String> availableCategories = [];
    for (final category in allCategories) {
      try {
        final questions = await loadQuestions(category);
        if (questions.isNotEmpty) {
          availableCategories.add(category);
        }
      } catch (e) {
        // Ignorer les catégories qui n'existent pas
      }
    }
    
    return availableCategories;
  }

  /// Vider le cache (utile après une mise à jour)
  static void clearCache() {
    _questionsCache.clear();
    _flashcardsCache.clear();
  }

  /// Obtenir le nombre total de questions par catégorie
  static Future<Map<String, int>> getQuestionCounts() async {
    final Map<String, int> counts = {};
    final categories = await getAvailableCategories();

    for (final category in categories) {
      final questions = await loadQuestions(category);
      counts[category] = questions.length;
    }

    return counts;
  }

  /// Obtenir le nombre de questions pour une catégorie spécifique
  static Future<int> getQuestionCount(String category) async {
    final questions = await loadQuestions(category);
    return questions.length;
  }

  /// Obtenir le nombre total de flashcards par catégorie
  static Future<Map<String, int>> getFlashcardCounts() async {
    final Map<String, int> counts = {};
    final categories = await getAvailableCategories();

    for (final category in categories) {
      final flashcards = await loadFlashcards(category);
      counts[category] = flashcards.length;
    }

    return counts;
  }
}
