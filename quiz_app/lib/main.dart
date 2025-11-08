import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'theme/redhat_theme.dart';

void main() async {
  // Assurer l'initialisation de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le stockage local
  await StorageService.initialize();
  
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App - Certification Training',
      debugShowCheckedModeBanner: false,
      theme: RedHatTheme.getTheme(),
      home: const HomeScreen(),
    );
  }
}

