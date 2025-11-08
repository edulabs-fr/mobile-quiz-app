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

  // Liste des écrans
  static const List<Widget> _screens = [
    QuizScreen(),
    FlashcardsScreen(),
    QuickRevisionScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
