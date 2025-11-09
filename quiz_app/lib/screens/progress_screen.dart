import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:quiz_app/services/storage_service.dart';
import 'package:quiz_app/widgets/stat_card.dart';

/// Écran de progression et statistiques
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // Clé pour forcer le rafraîchissement
  Key _futureBuilderKey = UniqueKey();

  void _refreshData() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  void _resetProgress() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser l\'historique'),
        content: const Text(
          'Êtes-vous sûr ? Cette action supprimera tout votre historique de quiz. '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        StorageService.clearAllResults();
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Historique supprimé'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  Future<Map<String, dynamic>> _loadProgressData() async {
    final results = StorageService.getAllResults();
    final averageScore = StorageService.getAverageScore();
    final topScore = StorageService.getTopScore();
    return {
      'results': results,
      'averageScore': averageScore,
      'topScore': topScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progression'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Réinitialiser l\'historique',
            onPressed: _resetProgress,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        key: _futureBuilderKey,
        future: _loadProgressData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || (snapshot.data!['results'] as List).isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insights,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucune donnée',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Complétez votre premier quiz pour voir vos statistiques ici !',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          
          final results = snapshot.data!['results'] as List<QuizResult>;
          final averageScore = snapshot.data!['averageScore'];
          final topScore = snapshot.data!['topScore'];

          return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Statistiques globales
                  Text(
                    'Statistiques globales',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.assessment,
                          title: 'Score moyen',
                          value: '${averageScore.toStringAsFixed(1)}%',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.emoji_events,
                          title: 'Meilleur score',
                          value: '${topScore.toStringAsFixed(1)}%',
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.quiz,
                          title: 'Quiz complétés',
                          value: '${results.length}',
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle,
                          title: 'Total questions',
                          value: '${results.fold<double>(0.0, (sum, r) => sum + r.questionsTotal)}',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Statistiques par difficulté
                  Text(
                    'Moyenne par difficulté',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final difficultyAverages = StorageService.getAverageScoreByDifficulty();
                      
                      return Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.emoji_events,
                              title: 'Facile',
                              value: '${(difficultyAverages['facile'] ?? 0).toStringAsFixed(1)}%',
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.emoji_events,
                              title: 'Moyen',
                              value: '${(difficultyAverages['moyen'] ?? 0).toStringAsFixed(1)}%',
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.emoji_events,
                              title: 'Difficile',
                              value: '${(difficultyAverages['difficile'] ?? 0).toStringAsFixed(1)}%',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Historique récent
                  Text(
                    'Historique récent',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ...StorageService.getRecentResults(limit: 20).map((result) {
                    final scoreColor = result.scorePercentage >= 80
                        ? Colors.green
                        : result.scorePercentage >= 60
                            ? Colors.orange
                            : Colors.red;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: scoreColor.withOpacity(0.2),
                          child: Text(
                            '${result.scorePercentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: scoreColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatCategoryName(result.category),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            // Chip pour les difficultés présentes
                            Wrap(
                              spacing: 4,
                              children: result.difficultiesPresentes.map((difficulty) {
                                Color chipColor;
                                switch (difficulty) {
                                  case 'facile':
                                    chipColor = Colors.green;
                                    break;
                                  case 'moyen':
                                    chipColor = Colors.orange;
                                    break;
                                  case 'difficile':
                                    chipColor = Colors.red;
                                    break;
                                  default:
                                    chipColor = Colors.grey;
                                }
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: chipColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: chipColor, width: 0.5),
                                  ),
                                  child: Text(
                                    difficulty[0].toUpperCase() + difficulty.substring(1),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: chipColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${result.correct}/${result.questionsTotal} correctes • '
                          '${result.averageTimePerQuestion.toStringAsFixed(1)}s/question',
                        ),
                        trailing: Text(
                          _formatDate(result.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
        },
      ),
    );
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Widget pour afficher une statistique
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
