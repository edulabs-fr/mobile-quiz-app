import 'dart:math';
import '../models/question.dart';

/// Service pour gérer la logique du quiz
class QuizEngine {
  final List<Question> allQuestions;
  late List<Question> currentQuestions;
  int currentIndex = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  final List<int> questionTimes = [];
  final Map<String, bool> answerResults = {}; // Stocker les résultats par question ID
  DateTime? questionStartTime;

  QuizEngine(this.allQuestions);

  /// Initialiser un nouveau quiz avec randomisation
  void initializeQuiz({int? numberOfQuestions}) {
    // Copier toutes les questions
    List<Question> shuffledQuestions = List.from(allQuestions);

    // Mélanger les questions
    shuffledQuestions.shuffle(Random());

    // Limiter le nombre de questions si spécifié
    if (numberOfQuestions != null && numberOfQuestions < shuffledQuestions.length) {
      currentQuestions = shuffledQuestions.take(numberOfQuestions).toList();
    } else {
      currentQuestions = shuffledQuestions;
    }

    // Mélanger les options de chaque question
    currentQuestions = currentQuestions.map((q) => q.withShuffledOptions()).toList();

    // Réinitialiser les compteurs
    currentIndex = 0;
    correctAnswers = 0;
    incorrectAnswers = 0;
    questionTimes.clear();
    answerResults.clear();
    questionStartTime = DateTime.now();
  }

  /// Obtenir la question actuelle
  Question? getCurrentQuestion() {
    if (currentIndex < currentQuestions.length) {
      return currentQuestions[currentIndex];
    }
    return null;
  }

  /// Vérifier une réponse et passer à la suivante
  bool checkAnswer(String answer) {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion == null) return false;

    // Enregistrer le temps de réponse
    if (questionStartTime != null) {
      final timeSpent = DateTime.now().difference(questionStartTime!).inSeconds;
      questionTimes.add(timeSpent);
    }

    // Vérifier la réponse
    final isCorrect = currentQuestion.isCorrectAnswer(answer);

    // Enregistrer le résultat par question
    answerResults[currentQuestion.id] = isCorrect;

    if (isCorrect) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }

    return isCorrect;
  }

  /// Vérifier plusieurs réponses (pour questions à choix multiples)
  bool checkMultipleAnswers(List<String> answers) {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion == null) return false;

    // Enregistrer le temps de réponse
    if (questionStartTime != null) {
      final timeSpent = DateTime.now().difference(questionStartTime!).inSeconds;
      questionTimes.add(timeSpent);
    }

    // Vérifier les réponses
    final isCorrect = currentQuestion.areCorrectAnswers(answers);

    // Enregistrer le résultat par question
    answerResults[currentQuestion.id] = isCorrect;

    if (isCorrect) {
      correctAnswers++;
    } else {
      incorrectAnswers++;
    }

    return isCorrect;
  }

  /// Passer à la question suivante
  void nextQuestion() {
    if (currentIndex < currentQuestions.length) {
      currentIndex++;
      if (!isQuizFinished()) {
        questionStartTime = DateTime.now();
      }
    }
  }

  /// Vérifier si le quiz est terminé
  bool isQuizFinished() {
    return currentIndex >= currentQuestions.length;
  }

  /// Vérifier si c'est la dernière question
  bool isLastQuestion() {
    return currentIndex == currentQuestions.length - 1;
  }

  /// Obtenir le score en pourcentage
  double getScorePercentage() {
    final total = correctAnswers + incorrectAnswers;
    if (total == 0) return 0.0;
    return (correctAnswers / total) * 100;
  }

  /// Obtenir le temps moyen par question
  double getAverageTimePerQuestion() {
    if (questionTimes.isEmpty) return 0.0;
    final sum = questionTimes.reduce((a, b) => a + b);
    return sum / questionTimes.length;
  }

  /// Obtenir le nombre total de questions
  int getTotalQuestions() {
    return currentQuestions.length;
  }

  /// Obtenir le nombre de questions restantes
  int getRemainingQuestions() {
    return currentQuestions.length - currentIndex - 1;
  }

  /// Obtenir la progression (0.0 à 1.0)
  double getProgress() {
    if (currentQuestions.isEmpty) return 0.0;
    return (currentIndex + 1) / currentQuestions.length;
  }

  /// Marquer la question actuelle
  void markCurrentQuestion() {
    final currentQuestion = getCurrentQuestion();
    if (currentQuestion != null) {
      currentQuestion.isMarked = !currentQuestion.isMarked;
    }
  }

  /// Obtenir toutes les questions marquées
  List<Question> getMarkedQuestions() {
    return currentQuestions.where((q) => q.isMarked).toList();
  }
}
