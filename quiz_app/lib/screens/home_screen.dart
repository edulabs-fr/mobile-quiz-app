import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'flashcards_screen.dart';
import 'progress_screen.dart';
import 'quick_revision_screen.dart';

// Clé globale pour accéder à l'état du QuizScreen
final quizScreenKey = GlobalKey<State>();

/// Écran d'accueil avec navigation principale
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des écrans - QuizScreen utilise la clé globale
  late final List<Widget> _screens = [
    QuizScreen(key: quizScreenKey),
    const FlashcardsScreen(),
    const QuickRevisionScreen(),
    const ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    // Si on est en plein quiz et on clique sur un autre onglet, afficher une confirmation
    final quizState = quizScreenKey.currentState;
    final isQuizActive = (quizState as dynamic)?.isQuizActive ?? false;
    
    if (_selectedIndex == 0 && isQuizActive && index != 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz en cours'),
          content: const Text('Êtes-vous sûr de vouloir quitter le quiz ? Vos progrès ne seront pas sauvegardés.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuer le quiz'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                // Quitter le quiz via la méthode du QuizScreen
                (quizState as dynamic)?.quitQuiz();
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: const Text('Quitter'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Flashcards',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outlined),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Révision',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Progression',
          ),
        ],
      ),
    );
  }
}
