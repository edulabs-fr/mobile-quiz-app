import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'flashcards_screen.dart';
import 'progress_screen.dart';
import 'quick_revision_screen.dart';

/// Écran d'accueil avec navigation principale
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isQuizActive = false;

  // Liste des écrans
  static const List<Widget> _screens = [
    QuizScreen(),
    FlashcardsScreen(),
    QuickRevisionScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    // Si on est en plein quiz et on clique sur un autre onglet, afficher une confirmation
    if (_selectedIndex == 0 && _isQuizActive && index != 0) {
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
                setState(() {
                  _selectedIndex = index;
                  _isQuizActive = false;
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
