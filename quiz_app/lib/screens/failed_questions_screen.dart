import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Écran pour afficher et gérer les questions échouées
class FailedQuestionsScreen extends StatefulWidget {
  const FailedQuestionsScreen({super.key});

  @override
  State<FailedQuestionsScreen> createState() => _FailedQuestionsScreenState();
}

class _FailedQuestionsScreenState extends State<FailedQuestionsScreen> {
  String? selectedCategory; // Filtrer par catégorie
  String? selectedDifficulty; // Filtrer par difficulté
  Set<String> selectedQuestionIds = {}; // Questions sélectionnées à réviser

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Erreurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Effacer toutes les erreurs',
            onPressed: _clearAllErrors,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filtres
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Filtrer par catégorie
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterChip(
                          label: selectedCategory ?? 'Catégorie',
                          onSelected: () => _showCategoryFilter(),
                          isActive: selectedCategory != null,
                        ),
                      ),
                      // Filtrer par difficulté
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterChip(
                          label: selectedDifficulty ?? 'Difficulté',
                          onSelected: () => _showDifficultyFilter(),
                          isActive: selectedDifficulty != null,
                        ),
                      ),
                      // Bouton réinitialiser filtres
                      if (selectedCategory != null || selectedDifficulty != null)
                        FilterChip(
                          label: const Text('Réinitialiser'),
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = null;
                              selectedDifficulty = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Bouton Réviser
                if (selectedQuestionIds.isNotEmpty)
                  FilledButton.icon(
                    onPressed: () => _startRevisionQuiz(),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      'Réviser ${selectedQuestionIds.length} question${selectedQuestionIds.length > 1 ? 's' : ''}',
                    ),
                  ),
              ],
            ),
          ),
          // Liste des erreurs
          Expanded(
            child: _buildFailedQuestionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onSelected,
    required bool isActive,
  }) {
    return FilterChip(
      label: Text(label),
      onSelected: (_) => onSelected(),
      selected: isActive,
      selectedColor: const Color(0xFFEE0000).withOpacity(0.2),
    );
  }

  Widget _buildFailedQuestionsList() {
    final failedQuestions = StorageService.getFailedQuestions();

    // Appliquer les filtres
    var filtered = failedQuestions.where((q) {
      if (selectedCategory != null && q['category'] != selectedCategory) {
        return false;
      }
      if (selectedDifficulty != null && q['difficulty'] != selectedDifficulty) {
        return false;
      }
      return true;
    }).toList();

    // Trier par nombre d'erreurs (décroissant)
    filtered.sort((a, b) {
      final countA = a['failureCount'] as int? ?? 1;
      final countB = b['failureCount'] as int? ?? 1;
      return countB.compareTo(countA);
    });

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aucune erreur !',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bravo, vous maîtrisez bien ce sujet !',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final failedQ = filtered[index];
        final questionId = failedQ['questionId'] as String;
        final isSelected = selectedQuestionIds.contains(questionId);
        final failureCount = failedQ['failureCount'] as int? ?? 1;
        final difficulty = failedQ['difficulty'] as String? ?? 'unknown';
        final category = failedQ['category'] as String? ?? 'unknown';
        final question = failedQ['question'] as String? ?? 'Question';

        // Couleur par difficulté
        Color diffColor;
        switch (difficulty) {
          case 'facile':
            diffColor = Colors.green;
            break;
          case 'moyen':
            diffColor = Colors.orange;
            break;
          case 'difficile':
            diffColor = Colors.red;
            break;
          default:
            diffColor = Colors.grey;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected ? Colors.blue.shade50 : null,
          child: ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedQuestionIds.add(questionId);
                  } else {
                    selectedQuestionIds.remove(questionId);
                  }
                });
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.length > 80 ? '${question.substring(0, 77)}...' : question,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: diffColor, width: 0.5),
                      ),
                      child: Text(
                        difficulty[0].toUpperCase() + difficulty.substring(1),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: diffColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatCategoryName(category),
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${failureCount}x',
                        style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _removeError(questionId),
            ),
          ),
        );
      },
    );
  }

  void _showCategoryFilter() {
    final failedQuestions = StorageService.getFailedQuestions();
    final categories = <String>{
      for (final q in failedQuestions) q['category'] as String? ?? 'unknown'
    }.toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par catégorie'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final cat in categories)
                RadioListTile<String>(
                  title: Text(_formatCategoryName(cat)),
                  value: cat,
                  groupValue: selectedCategory,
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDifficultyFilter() {
    const difficulties = ['facile', 'moyen', 'difficile'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer par difficulté'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final diff in difficulties)
              RadioListTile<String>(
                title: Text(diff[0].toUpperCase() + diff.substring(1)),
                value: diff,
                groupValue: selectedDifficulty,
                onChanged: (value) {
                  setState(() => selectedDifficulty = value);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _removeError(String questionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette erreur ?'),
        content: const Text('Cette action supprimera l\'erreur de votre historique.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              await StorageService.removeFailedQuestion(questionId);
              selectedQuestionIds.remove(questionId);
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _clearAllErrors() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer toutes les erreurs ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              await StorageService.clearFailedQuestions();
              selectedQuestionIds.clear();
              if (mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

  void _startRevisionQuiz() {
    // TODO: Implémenter le quiz de révision avec les questions sélectionnées
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz de révision avec ${selectedQuestionIds.length} question(s) - À venir !'),
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
