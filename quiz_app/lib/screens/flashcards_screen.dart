import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';
import '../models/flashcard.dart';

/// Écran des Flashcards
class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  String? selectedCategory;
  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  Set<int> flipped = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await DataService.getAvailableCategories();
    if (categories.isNotEmpty) {
      setState(() {
        selectedCategory = categories.first;
      });
      _loadFlashcards();
    }
  }

  Future<void> _loadFlashcards() async {
    if (selectedCategory == null) return;
    
    final cards = await DataService.loadFlashcards(selectedCategory!);
    setState(() {
      flashcards = cards;
      currentIndex = 0;
      flipped.clear();
    });
  }

  void _nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        flipped.clear();
      });
    }
  }

  void _previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        flipped.clear();
      });
    }
  }

  void _toggleFlip() {
    setState(() {
      if (flipped.contains(currentIndex)) {
        flipped.remove(currentIndex);
      } else {
        flipped.add(currentIndex);
      }
    });
  }

  Future<void> _toggleMark() async {
    final card = flashcards[currentIndex];
    await StorageService.toggleMarkedFlashcard(card);
    setState(() {
      flashcards[currentIndex] = card;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: selectedCategory == null
          ? const Center(child: CircularProgressIndicator())
          : flashcards.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: [
                    // Sélecteur de catégorie
                    _buildCategorySelector(context),

                    // Flashcard
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildFlashcard(context),
                        ),
                      ),
                    ),

                    // Contrôles de navigation
                    _buildControls(context),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
              'Aucune flashcard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Il n\'y a pas de flashcards disponibles pour cette catégorie.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: DataService.getAvailableCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final categories = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_formatCategoryName(category)),
                  selected: isSelected,
                  onSelected: (value) {
                    setState(() {
                      selectedCategory = category;
                    });
                    _loadFlashcards();
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: const Color(0xFFEE0000),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFFEE0000)
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFlashcard(BuildContext context) {
    if (flashcards.isEmpty) {
      return const SizedBox.shrink();
    }

    final card = flashcards[currentIndex];
    final isFlipped = flipped.contains(currentIndex);
    final isMarked = StorageService.isFlashcardMarked(card.id);

    return GestureDetector(
      onTap: _toggleFlip,
      onHorizontalDragEnd: (details) {
        // Swipe vers la droite = précédent
        if (details.velocity.pixelsPerSecond.dx > 300) {
          _previousCard();
        }
        // Swipe vers la gauche = suivant
        else if (details.velocity.pixelsPerSecond.dx < -300) {
          _nextCard();
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Card(
          key: ValueKey(isFlipped),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isFlipped
                    ? [
                        const Color(0xFFEE0000).withOpacity(0.1),
                        const Color(0xFFEE0000).withOpacity(0.05),
                      ]
                    : [Colors.white, Colors.grey.shade50],
              ),
              border: Border.all(
                color: isFlipped
                    ? const Color(0xFFEE0000)
                    : Colors.grey.shade300,
                width: isFlipped ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // En-tête
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFlipped ? 'Explication' : 'Question',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isMarked
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: const Color(0xFFEE0000),
                        ),
                        onPressed: _toggleMark,
                        tooltip: 'Marquer cette flashcard',
                      ),
                    ],
                  ),
                ),

                // Contenu central
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isFlipped ? card.explanation : card.term,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        if (isFlipped && card.example != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFB8C00),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Exemple',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFB8C00),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  card.example!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Footer avec indication de flip
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currentIndex + 1} / ${flashcards.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Appuyez pour retourner',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bouton précédent
          SizedBox(
            width: 60,
            height: 60,
            child: FilledButton(
              onPressed: currentIndex > 0 ? _previousCard : null,
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.arrow_back),
            ),
          ),

          // Indicateur de progression
          Column(
            children: [
              Text(
                '${currentIndex + 1}/${flashcards.length}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEE0000),
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / flashcards.length,
                  minHeight: 4,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFEE0000),
                  ),
                ),
              ),
            ],
          ),

          // Bouton suivant
          SizedBox(
            width: 60,
            height: 60,
            child: FilledButton(
              onPressed: currentIndex < flashcards.length - 1
                  ? _nextCard
                  : null,
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
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

