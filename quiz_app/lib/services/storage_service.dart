import 'package:hive_flutter/hive_flutter.dart';
import '../models/question.dart';
import '../models/flashcard.dart';
import '../models/quiz_result.dart';

/// Service pour gérer le stockage local avec Hive
class StorageService {
  static const String _resultsBox = 'quiz_results';
  static const String _markedQuestionsBox = 'marked_questions';
  static const String _markedFlashcardsBox = 'marked_flashcards';
  static const String _settingsBox = 'settings';
  static const String _failedQuestionsBox = 'failed_questions'; // Nouvelles erreurs

  /// Initialiser Hive
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Enregistrer les adapters
    Hive.registerAdapter(QuestionAdapter());
    Hive.registerAdapter(FlashcardAdapter());
    Hive.registerAdapter(QuizResultAdapter());

    // Ouvrir les boxes
    await Hive.openBox<QuizResult>(_resultsBox);
    await Hive.openBox<Question>(_markedQuestionsBox);
    await Hive.openBox<Flashcard>(_markedFlashcardsBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_failedQuestionsBox); // Box pour les erreurs
  }

  // ==================== RÉSULTATS DE QUIZ ====================

  /// Sauvegarder un résultat de quiz
  static Future<void> saveQuizResult(QuizResult result) async {
    final box = Hive.box<QuizResult>(_resultsBox);
    await box.put(result.id, result);
  }

  /// Obtenir tous les résultats
  static List<QuizResult> getAllResults() {
    final box = Hive.box<QuizResult>(_resultsBox);
    return box.values.toList();
  }

  /// Obtenir les résultats par catégorie
  static List<QuizResult> getResultsByCategory(String category) {
    final box = Hive.box<QuizResult>(_resultsBox);
    return box.values.where((r) => r.category == category).toList();
  }

  /// Obtenir le score moyen global
  static double getAverageScore() {
    final results = getAllResults();
    if (results.isEmpty) return 0.0;

    double sum = 0;
    for (var result in results) {
      sum += result.scorePercentage;
    }
    return sum / results.length;
  }

  /// Obtenir le score moyen par catégorie
  static double getAverageScoreByCategory(String category) {
    final results = getResultsByCategory(category);
    if (results.isEmpty) return 0.0;

    double sum = 0;
    for (var result in results) {
      sum += result.scorePercentage;
    }
    return sum / results.length;
  }

  /// Obtenir le top score global
  static double getTopScore() {
    final results = getAllResults();
    if (results.isEmpty) return 0.0;

    double maxScore = 0;
    for (var result in results) {
      if (result.scorePercentage > maxScore) {
        maxScore = result.scorePercentage;
      }
    }
    return maxScore;
  }

  /// Obtenir le top score par catégorie
  static double getTopScoreByCategory(String category) {
    final results = getResultsByCategory(category);
    if (results.isEmpty) return 0.0;

    double maxScore = 0;
    for (var result in results) {
      if (result.scorePercentage > maxScore) {
        maxScore = result.scorePercentage;
      }
    }
    return maxScore;
  }

  /// Obtenir les derniers N résultats
  static List<QuizResult> getRecentResults({int limit = 10}) {
    final results = getAllResults();
    results.sort((a, b) => b.date.compareTo(a.date));
    return results.take(limit).toList();
  }

  /// Calculer le score moyen par difficulté
  static Map<String, double> getAverageScoreByDifficulty() {
    final results = getAllResults();
    final scoreByDifficulty = <String, List<double>>{};

    for (final result in results) {
      // Extraire les stats par difficulté
      final difficultyStats = result.difficultyStats;
      
      for (final difficulty in result.difficultiesPresentes) {
        if (!scoreByDifficulty.containsKey(difficulty)) {
          scoreByDifficulty[difficulty] = [];
        }

        // Calculer le score de ce quiz pour cette difficulté
        final stats = difficultyStats[difficulty];
        if (stats is Map) {
          final statsMap = Map<String, dynamic>.from(stats as Map);
          final total = statsMap['total'] as int? ?? 0;
          final correct = statsMap['correct'] as int? ?? 0;
          
          if (total > 0) {
            // Calculer le pourcentage basé sur la proportion du score total
            final scoreForDifficulty = (correct / total) * 100;
            scoreByDifficulty[difficulty]!.add(scoreForDifficulty);
          }
        }
      }
    }

    // Calculer les moyennes
    final averages = <String, double>{};
    scoreByDifficulty.forEach((difficulty, scores) {
      if (scores.isNotEmpty) {
        final sum = scores.fold<double>(0, (prev, score) => prev + score);
        averages[difficulty] = sum / scores.length;
      } else {
        averages[difficulty] = 0.0;
      }
    });

    return averages;
  }

  /// Effacer tout l'historique des résultats
  static Future<void> clearAllResults() async {
    final box = Hive.box<QuizResult>(_resultsBox);
    await box.clear();
  }

  // ==================== QUESTIONS MARQUÉES ====================

  /// Marquer/Démarquer une question
  static Future<void> toggleMarkedQuestion(Question question) async {
    final box = Hive.box<Question>(_markedQuestionsBox);
    
    if (box.containsKey(question.id)) {
      await box.delete(question.id);
      question.isMarked = false;
    } else {
      question.isMarked = true;
      await box.put(question.id, question);
    }
  }

  /// Obtenir toutes les questions marquées
  static List<Question> getMarkedQuestions() {
    final box = Hive.box<Question>(_markedQuestionsBox);
    return box.values.toList();
  }

  /// Obtenir les questions marquées par catégorie
  static List<Question> getMarkedQuestionsByCategory(String category) {
    final box = Hive.box<Question>(_markedQuestionsBox);
    return box.values.where((q) => q.category == category).toList();
  }

  /// Vérifier si une question est marquée
  static bool isQuestionMarked(String questionId) {
    final box = Hive.box<Question>(_markedQuestionsBox);
    return box.containsKey(questionId);
  }

  // ==================== FLASHCARDS MARQUÉES ====================

  /// Marquer/Démarquer une flashcard
  static Future<void> toggleMarkedFlashcard(Flashcard flashcard) async {
    final box = Hive.box<Flashcard>(_markedFlashcardsBox);
    
    if (box.containsKey(flashcard.id)) {
      await box.delete(flashcard.id);
      flashcard.isMarked = false;
    } else {
      flashcard.isMarked = true;
      await box.put(flashcard.id, flashcard);
    }
  }

  /// Obtenir toutes les flashcards marquées
  static List<Flashcard> getMarkedFlashcards() {
    final box = Hive.box<Flashcard>(_markedFlashcardsBox);
    return box.values.toList();
  }

  /// Obtenir les flashcards marquées par catégorie
  static List<Flashcard> getMarkedFlashcardsByCategory(String category) {
    final box = Hive.box<Flashcard>(_markedFlashcardsBox);
    return box.values.where((f) => f.category == category).toList();
  }

  /// Vérifier si une flashcard est marquée
  static bool isFlashcardMarked(String flashcardId) {
    final box = Hive.box<Flashcard>(_markedFlashcardsBox);
    return box.containsKey(flashcardId);
  }

  // ==================== QUESTIONS ÉCHOUÉES ====================

  /// Sauvegarder une question échouée
  static Future<void> saveFailedQuestion({
    required String questionId,
    required String category,
    required String difficulty,
    required String question,
    required List<String> correctAnswers,
  }) async {
    final box = Hive.box(_failedQuestionsBox);
    
    // Vérifier si la question existe déjà
    final existingKey = box.keys.cast<String>().firstWhere(
      (key) {
        final data = box.get(key) as Map?;
        return data?['questionId'] == questionId;
      },
      orElse: () => '',
    );

    if (existingKey.isNotEmpty) {
      // Question déjà échouée, incrémenter le count
      final data = box.get(existingKey) as Map;
      final failureCount = (data['failureCount'] as int? ?? 1) + 1;
      await box.put(existingKey, {
        ...data,
        'failureCount': failureCount,
        'date': DateTime.now().toIso8601String(),
      });
    } else {
      // Nouvelle erreur
      await box.put(
        '${DateTime.now().millisecondsSinceEpoch}',
        {
          'questionId': questionId,
          'category': category,
          'difficulty': difficulty,
          'question': question,
          'correctAnswers': correctAnswers,
          'date': DateTime.now().toIso8601String(),
          'failureCount': 1,
        },
      );
    }
  }

  /// Obtenir toutes les questions échouées
  static List<Map<String, dynamic>> getFailedQuestions() {
    final box = Hive.box(_failedQuestionsBox);
    return box.values.map((v) => Map<String, dynamic>.from(v as Map)).toList();
  }

  /// Obtenir les questions échouées par catégorie
  static List<Map<String, dynamic>> getFailedQuestionsByCategory(String category) {
    final box = Hive.box(_failedQuestionsBox);
    return box.values
        .where((v) => (v as Map)['category'] == category)
        .map((v) => Map<String, dynamic>.from(v as Map))
        .toList();
  }

  /// Obtenir les questions échouées par difficulté
  static List<Map<String, dynamic>> getFailedQuestionsByDifficulty(String difficulty) {
    final box = Hive.box(_failedQuestionsBox);
    return box.values
        .where((v) => (v as Map)['difficulty'] == difficulty)
        .map((v) => Map<String, dynamic>.from(v as Map))
        .toList();
  }

  /// Supprimer une question échouée
  static Future<void> removeFailedQuestion(String questionId) async {
    final box = Hive.box(_failedQuestionsBox);
    final keyToRemove = box.keys.cast<String>().firstWhere(
      (key) {
        final data = box.get(key) as Map?;
        return data?['questionId'] == questionId;
      },
      orElse: () => '',
    );
    
    if (keyToRemove.isNotEmpty) {
      await box.delete(keyToRemove);
    }
  }

  /// Effacer toutes les erreurs
  static Future<void> clearFailedQuestions() async {
    final box = Hive.box(_failedQuestionsBox);
    await box.clear();
  }

  // ==================== PARAMÈTRES ====================

  /// Sauvegarder un paramètre
  static Future<void> setSetting(String key, dynamic value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  /// Obtenir un paramètre
  static T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  /// Supprimer toutes les données (pour réinitialisation)
  static Future<void> clearAllData() async {
    await Hive.box<QuizResult>(_resultsBox).clear();
    await Hive.box<Question>(_markedQuestionsBox).clear();
    await Hive.box<Flashcard>(_markedFlashcardsBox).clear();
    await Hive.box(_settingsBox).clear();
    await Hive.box(_failedQuestionsBox).clear();
  }
}
