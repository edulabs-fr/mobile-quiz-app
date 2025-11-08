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
  }
}
