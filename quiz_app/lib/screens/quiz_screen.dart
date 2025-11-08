import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/quiz_engine.dart';
import '../services/storage_service.dart';
import '../models/quiz_result.dart';
import '../models/question.dart';

/// Écran principal du Quiz
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Set<String> selectedCategories = {}; // Changé en Set pour sélection multiple
  int? selectedQuestionCount;
  QuizEngine? quizEngine;
  bool isQuizActive = false;
  Set<String> selectedAnswers = {}; // Changé pour supporter les choix multiples
  bool showResult = false;
  bool? isCorrect;
  Map<String, int> categoryQuestionCounts = {};

  // Les options de nombre de questions seront maintenant "10", "20", "40", "Toutes"
  // On utilisera -1 pour représenter "Toutes"
  final List<int> questionCounts = [10, 20, 40, -1];

  /// Charger les catégories avec le nombre de questions
  Future<Map<String, dynamic>> _loadCategoriesWithCounts() async {
    final categories = await DataService.getAvailableCategories();
    final counts = <String, int>{};
    
    for (final category in categories) {
      final count = await DataService.getQuestionCount(category);
      counts[category] = count;
    }
    
    return {
      'categories': categories,
      'counts': counts,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isQuizActive && quizEngine != null) {
      return _buildQuizView();
    } else {
      return _buildSetupView();
    }
  }

  /// Vue de configuration du quiz
  Widget _buildSetupView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz - Entraînement'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadCategoriesWithCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Aucune catégorie disponible'),
            );
          }

          final categories = snapshot.data!['categories'] as List<String>;
          categoryQuestionCounts = snapshot.data!['counts'] as Map<String, int>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Comment ça marche ?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. Choisissez une catégorie\n'
                          '2. Sélectionnez le nombre de questions\n'
                          '3. Répondez aux questions\n'
                          '4. Consultez vos résultats !',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sélection de catégorie
                Text(
                  'Sélectionnez une ou plusieurs catégories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...categories.map((category) {
                  final questionCount = categoryQuestionCounts[category] ?? 0;
                  final isSelected = selectedCategories.contains(category);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                      title: Text(
                        _formatCategoryName(category),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        '$questionCount question${questionCount > 1 ? 's' : ''} disponible${questionCount > 1 ? 's' : ''}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      activeColor: const Color(0xFFEE0000), // Red Hat Red
                      checkColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Sélection du nombre de questions
                Text(
                  'Nombre de questions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...questionCounts.map((count) {
                  // Calculer le total disponible de toutes les catégories sélectionnées
                  int totalAvailable = 0;
                  for (final category in selectedCategories) {
                    totalAvailable += categoryQuestionCounts[category] ?? 0;
                  }
                  
                  // Si "Toutes" est sélectionné (count = -1), afficher le nombre total
                  final displayText = count == -1 
                      ? 'Toutes questions ($totalAvailable)'
                      : '$count questions';
                  
                  // Désactiver l'option si elle dépasse le nombre disponible
                  final isEnabled = count == -1 || count <= totalAvailable;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: isEnabled ? null : Colors.grey.shade200,
                    child: RadioListTile<int>(
                      value: count,
                      groupValue: selectedQuestionCount,
                      onChanged: isEnabled ? (value) {
                        setState(() {
                          selectedQuestionCount = value;
                        });
                      } : null,
                      title: Text(
                        displayText,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      activeColor: const Color(0xFFEE0000), // Red Hat Red
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                  );
                }),
                const SizedBox(height: 32),

                // Bouton Démarrer
                FilledButton.icon(
                  onPressed: selectedCategories.isNotEmpty &&
                          selectedQuestionCount != null
                      ? _startQuiz
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Démarrer le Quiz'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Vue du quiz en cours
  Widget _buildQuizView() {
    final question = quizEngine!.getCurrentQuestion();
    if (question == null) {
      return _buildResultView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${quizEngine!.currentIndex + 1}/${quizEngine!.getTotalQuestions()}',
        ),
        actions: [
          // Progression
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${(quizEngine!.getProgress() * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de progression
          LinearProgressIndicator(
            value: quizEngine!.getProgress(),
            minHeight: 6,
          ),

          // Contenu de la question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre et bouton de marquage
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  question.question,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: Icon(
                                  StorageService.isQuestionMarked(question.id)
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: Colors.orange,
                                ),
                                onPressed: () async {
                                  await StorageService.toggleMarkedQuestion(question);
                                  setState(() {});
                                },
                                tooltip: 'Marquer cette question',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Métadonnées de la question
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (question.isMultipleChoice)
                                Chip(
                                  label: const Text('Choix multiples'),
                                  avatar: const Icon(Icons.check_box, size: 16),
                                  backgroundColor: Colors.blue.shade100,
                                ),
                              Chip(
                                label: Text(question.difficulty),
                                avatar: Icon(
                                  question.difficulty == 'facile'
                                      ? Icons.sentiment_satisfied
                                      : question.difficulty == 'moyen'
                                          ? Icons.sentiment_neutral
                                          : Icons.sentiment_dissatisfied,
                                  size: 16,
                                ),
                                backgroundColor: question.difficulty == 'facile'
                                    ? Colors.green.shade100
                                    : question.difficulty == 'moyen'
                                        ? Colors.orange.shade100
                                        : Colors.red.shade100,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options de réponse
                  ...question.options.asMap().entries.map((entry) {
                    final option = entry.value;
                    final isSelected = selectedAnswers.contains(option);
                    
                    Color? cardColor;
                    if (showResult && isSelected) {
                      // Si l'option est sélectionnée et c'est une bonne réponse
                      if (question.correctAnswers.contains(option)) {
                        cardColor = Colors.green.shade100;
                      } else {
                        // Option sélectionnée mais incorrecte
                        cardColor = Colors.red.shade100;
                      }
                    } else if (showResult && question.correctAnswers.contains(option)) {
                      // Afficher les bonnes réponses non sélectionnées
                      cardColor = Colors.green.shade50;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: cardColor,
                      child: InkWell(
                        onTap: showResult
                            ? null
                            : () {
                                setState(() {
                                  if (question.isMultipleChoice) {
                                    // Choix multiples : toggle
                                    if (isSelected) {
                                      selectedAnswers.remove(option);
                                    } else {
                                      selectedAnswers.add(option);
                                    }
                                  } else {
                                    // Choix unique : remplacer
                                    selectedAnswers.clear();
                                    selectedAnswers.add(option);
                                  }
                                });
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Checkbox pour choix multiples, Radio pour choix unique
                              if (question.isMultipleChoice)
                                Checkbox(
                                  value: isSelected,
                                  onChanged: showResult
                                      ? null
                                      : (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedAnswers.add(option);
                                            } else {
                                              selectedAnswers.remove(option);
                                            }
                                          });
                                        },
                                )
                              else
                                Radio<String>(
                                  value: option,
                                  groupValue: selectedAnswers.isEmpty ? null : selectedAnswers.first,
                                  onChanged: showResult
                                      ? null
                                      : (value) {
                                          setState(() {
                                            selectedAnswers.clear();
                                            if (value != null) {
                                              selectedAnswers.add(value);
                                            }
                                          });
                                        },
                                ),
                              Expanded(
                                child: Text(
                                  option,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              if (showResult && question.correctAnswers.contains(option))
                                const Icon(Icons.check_circle, color: Colors.green),
                              if (showResult && isSelected && !question.correctAnswers.contains(option))
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  // Affichage du résultat
                  if (showResult) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: isCorrect! ? Colors.green.shade50 : Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect! ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect! ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isCorrect! ? 'Correct !' : 'Incorrect',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: isCorrect! ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Explication :',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(question.explanation),
                            if (question.hint != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Astuce :',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                question.hint!,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Boutons d'action
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (!showResult)
                  Expanded(
                    child: FilledButton(
                      onPressed: selectedAnswers.isNotEmpty ? _checkAnswer : null,
                      child: const Text('Valider'),
                    ),
                  ),
                if (showResult)
                  Expanded(
                    child: FilledButton(
                      onPressed: _nextQuestion,
                      child: Text(
                        quizEngine!.isLastQuestion()
                            ? 'Voir les résultats'
                            : 'Question suivante',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Vue des résultats finaux
  Widget _buildResultView() {
    final score = quizEngine!.getScorePercentage();
    final avgTime = quizEngine!.getAverageTimePerQuestion();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
        actions: [
          // Bouton pour effacer tout l'historique
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Effacer tout l\'historique',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmer la suppression'),
                  content: const Text(
                    'Voulez-vous effacer tout l\'historique des quiz ? '
                    'Cette action est irréversible.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Effacer'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                await StorageService.clearAllResults();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Historique effacé'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score global
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    score >= 80
                        ? Icons.celebration
                        : score >= 60
                            ? Icons.thumb_up
                            : Icons.trending_up,
                    size: 100,
                    color: score >= 80
                        ? Colors.green
                        : score >= 60
                            ? Colors.orange
                            : Colors.red,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quiz terminé !',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            '${score.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${quizEngine!.correctAnswers} / ${quizEngine!.getTotalQuestions()} correctes',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Temps moyen : ${avgTime.toStringAsFixed(1)}s/question',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Détail de toutes les questions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Détail des questions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...quizEngine!.currentQuestions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    final wasCorrect = index < quizEngine!.correctAnswers + quizEngine!.incorrectAnswers;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: wasCorrect && quizEngine!.correctAnswers > 0
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: wasCorrect && quizEngine!.correctAnswers > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        title: Text(
                          question.question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Réponse(s) correcte(s) :',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                ...question.correctAnswers.map((answer) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Colors.green, size: 16),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(answer)),
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 12),
                                Text(
                                  'Explication :',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(question.explanation),
                                if (question.reference != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Référence : ${question.reference}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Boutons
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    isQuizActive = false;
                    quizEngine = null;
                    selectedAnswers.clear();
                    showResult = false;
                  });
                },
                icon: const Icon(Icons.home),
                label: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Démarrer le quiz
  Future<void> _startQuiz() async {
    if (selectedCategories.isEmpty || selectedQuestionCount == null) return;

    // Si selectedQuestionCount est -1, on prend toutes les questions
    final numberOfQuestions = selectedQuestionCount == -1 
        ? null 
        : selectedQuestionCount;

    // Charger les questions de toutes les catégories sélectionnées
    Map<String, List<Question>> questionsByCategory = {};
    
    for (final category in selectedCategories) {
      final questions = await DataService.loadQuestions(category);
      if (questions.isNotEmpty) {
        questionsByCategory[category] = questions;
      }
    }

    if (questionsByCategory.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune question disponible pour les catégories sélectionnées'),
          ),
        );
      }
      return;
    }

    // Distribuer les questions de manière équitable entre les catégories
    List<Question> allQuestions = [];
    
    if (numberOfQuestions == null) {
      // Prendre toutes les questions
      for (final questions in questionsByCategory.values) {
        allQuestions.addAll(questions);
      }
    } else {
      // Distribuer équitablement
      final numCategories = questionsByCategory.length;
      final questionsPerCategory = numberOfQuestions ~/ numCategories; // Division entière
      final remainder = numberOfQuestions % numCategories; // Reste
      
      int categoryIndex = 0;
      for (final category in questionsByCategory.keys) {
        final questions = questionsByCategory[category]!;
        
        // Ajouter des questions supplémentaires au début si reste > 0
        final count = questionsPerCategory + (categoryIndex < remainder ? 1 : 0);
        final questionsToAdd = questions.take(count).toList();
        
        allQuestions.addAll(questionsToAdd);
        categoryIndex++;
      }
    }

    if (allQuestions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucune question disponible pour les catégories sélectionnées'),
          ),
        );
      }
      return;
    }

    setState(() {
      quizEngine = QuizEngine(allQuestions);
      quizEngine!.initializeQuiz(numberOfQuestions: allQuestions.length);
      isQuizActive = true;
      selectedAnswers.clear();
      showResult = false;
    });
  }

  /// Vérifier la réponse
  void _checkAnswer() {
    if (selectedAnswers.isEmpty) return;

    final currentQuestion = quizEngine!.getCurrentQuestion();
    if (currentQuestion == null) return;

    // Utiliser la méthode appropriée selon le type de question
    final correct = currentQuestion.isMultipleChoice
        ? quizEngine!.checkMultipleAnswers(selectedAnswers.toList())
        : quizEngine!.checkAnswer(selectedAnswers.first);

    setState(() {
      isCorrect = correct;
      showResult = true;
    });
  }

  /// Passer à la question suivante
  Future<void> _nextQuestion() async {
    // Si c'est la dernière question, on sauvegarde et on affiche les résultats
    if (quizEngine!.isLastQuestion()) {
      // Sauvegarder le résultat
      final categoriesName = selectedCategories.join(', ');
      final result = QuizResult(
        id: QuizResult.generateId(),
        date: DateTime.now(),
        category: categoriesName,
        questionsTotal: quizEngine!.getTotalQuestions(),
        correct: quizEngine!.correctAnswers,
        incorrect: quizEngine!.incorrectAnswers,
        averageTimePerQuestion: quizEngine!.getAverageTimePerQuestion(),
      );
      await StorageService.saveQuizResult(result);
      
      // Passer à l'état "fini" pour que isQuizFinished devienne vrai
      quizEngine!.nextQuestion();

      setState(() {
        // On ne réinitialise rien ici, on laisse _buildResultView s'afficher
      });
    } else {
      // Continuer avec la question suivante
      quizEngine!.nextQuestion();
      setState(() {
        selectedAnswers.clear();
        showResult = false;
        isCorrect = null;
      });
    }
  }

  /// Formater le nom de la catégorie
  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
