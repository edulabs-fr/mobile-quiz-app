import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/question.dart';
import '../theme/redhat_theme.dart';

/// Écran de révision rapide avec les questions et flashcards marquées
class QuickRevisionScreen extends StatefulWidget {
  const QuickRevisionScreen({super.key});

  @override
  State<QuickRevisionScreen> createState() => _QuickRevisionScreenState();
}

class _QuickRevisionScreenState extends State<QuickRevisionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Révision rapide'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.help_outline),
              text: 'Questions',
            ),
            Tab(
              icon: Icon(Icons.library_books),
              text: 'Flashcards',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMarkedQuestionsView(),
          _buildMarkedFlashcardsView(),
        ],
      ),
    );
  }

  /// Vue des questions marquées
  Widget _buildMarkedQuestionsView() {
    final markedQuestions = StorageService.getMarkedQuestions();

    if (markedQuestions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_outline,
                size: 100,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucune question marquée',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Marquez les questions difficiles pendant les quiz pour les réviser ici !',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${markedQuestions.length} question${markedQuestions.length > 1 ? 's' : ''} marquée${markedQuestions.length > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Effacer tout',
                  onPressed: _clearAllMarkedQuestions,
                ),
              ],
            ),
          ),
          ...markedQuestions.map((question) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête avec catégorie et difficulté
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatCategoryName(question.category),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(question.difficulty),
                          backgroundColor: _getDifficultyColor(question.difficulty),
                          labelStyle: const TextStyle(fontSize: 12),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Question
                    Text(
                      question.question,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Options
                    ...question.options.map((option) {
                      final isCorrect =
                          question.correctAnswers.contains(option);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              isCorrect
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 18,
                              color: isCorrect ? const Color(0xFF4CAF50) : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isCorrect
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey.shade700,
                                  fontWeight: isCorrect
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    // Explication
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD), // Light blue
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explication :',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.explanation,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (question.hint != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0), // Light orange
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Astuce :',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              question.hint!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Bouton pour retirer du marquage
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_remove),
                        label: const Text('Retirer du marquage'),
                        onPressed: () async {
                          await StorageService.toggleMarkedQuestion(question);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Vue des flashcards marquées
  Widget _buildMarkedFlashcardsView() {
    final markedFlashcards = StorageService.getMarkedFlashcards();

    if (markedFlashcards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books,
                size: 100,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Aucune flashcard marquée',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Marquez les flashcards importants pour les réviser ici !',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${markedFlashcards.length} flashcard${markedFlashcards.length > 1 ? 's' : ''} marquée${markedFlashcards.length > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Effacer tout',
                  onPressed: _clearAllMarkedFlashcards,
                ),
              ],
            ),
          ),
          ...markedFlashcards.map((flashcard) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Catégorie
                    Text(
                      _formatCategoryName(flashcard.category),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Question
                    Text(
                      'Q: ${flashcard.term}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Réponse
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9), // Light green
                          borderRadius: BorderRadius.circular(8),
                        ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'R: ${flashcard.explanation}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Bouton pour retirer du marquage
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bookmark_remove),
                        label: const Text('Retirer du marquage'),
                        onPressed: () async {
                          await StorageService.toggleMarkedFlashcard(flashcard);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _clearAllMarkedQuestions() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les questions marquées'),
        content: const Text(
          'Êtes-vous sûr ? Cette action supprimera toutes les questions marquées.',
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
    ).then((confirmed) {
      if (confirmed == true) {
        final questions = StorageService.getMarkedQuestions();
        for (final question in questions) {
          StorageService.toggleMarkedQuestion(question);
        }
        setState(() {});
      }
    });
  }

  void _clearAllMarkedFlashcards() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les flashcards marquées'),
        content: const Text(
          'Êtes-vous sûr ? Cette action supprimera toutes les flashcards marquées.',
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
    ).then((confirmed) {
      if (confirmed == true) {
        final flashcards = StorageService.getMarkedFlashcards();
        for (final flashcard in flashcards) {
          StorageService.toggleMarkedFlashcard(flashcard);
        }
        setState(() {});
      }
    });
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return const Color(0xFFE8F5E9); // Light green
      case 'moyen':
        return const Color(0xFFFFF3E0); // Light orange
      case 'difficile':
        return const Color(0xFFFFEBEE); // Light red
      default:
        return const Color(0xFFF5F5F5); // Light gray
    }
  }

  Color _getScoreColor(Question question) {
    final score = question.points;
    if (score <= 1) return const Color(0xFF4CAF50); // Green
    if (score <= 2) return const Color(0xFFFB8C00); // Orange
    return RedHatTheme.redHatRed; // Red Hat Red
  }
}
