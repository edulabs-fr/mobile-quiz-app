# 🎓 Quiz App - Application d'Entraînement aux Certifications

Application mobile Flutter pour s'entraîner aux certifications (RHCSA, AWS, Azure, etc.) avec des QCM et des flashcards.

## 📱 Fonctionnalités du MVP

### ✅ Implémenté dans cette version

- **Quiz interactifs** :
  - Sélection de catégorie (User Management, Filesystem, Networking, Security)
  - Choix du nombre de questions (10, 20, 40)
  - Questions randomisées à chaque session
  - Affichage des explications et hints après chaque réponse
  - Feedback visuel (vert = correct, rouge = incorrect)
  
- **Système de progression** :
  - Sauvegarde automatique des résultats
  - Statistiques globales (score moyen, meilleur score)
  - Historique des quiz complétés
  - Compteur de questions répondues
  
- **Interface moderne** :
  - Navigation par onglets (Quiz, Flashcards, Progression)
  - Design Material 3
  - Thème cohérent et professionnel

### 🚧 À venir dans les prochaines versions

- **Flashcards** : Révision des concepts par catégorie
- **Marquage** : Sauvegarder les questions difficiles
- **Mode examen** : Quiz chronométré sans correction immédiate
- **Mises à jour** : Téléchargement automatique de nouvelles questions

## 🛠️ Installation et Lancement

### Prérequis

- Flutter SDK 3.24.5 ou supérieur
- Dart SDK (inclus avec Flutter)

### Configuration

1. **Cloner le projet** :
   ```bash
   cd /home/vrm/mobile-quiz-app/mobile-quiz-app/quiz_app
   ```

2. **Installer les dépendances** :
   ```bash
   ~/flutter/bin/flutter pub get
   ```

3. **Lancer l'application** :
   
   **Pour un émulateur Android/iOS** :
   ```bash
   ~/flutter/bin/flutter run
   ```
   
   **Pour Chrome (Web)** :
   ```bash
   ~/flutter/bin/flutter run -d chrome
   ```

4. **Compiler pour Android (APK)** :
   ```bash
   ~/flutter/bin/flutter build apk --release
   ```
   L'APK sera dans : `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Structure du Projet

```
quiz_app/
├── lib/
│   ├── main.dart                 # Point d'entrée de l'app
│   ├── models/                   # Modèles de données
│   │   ├── question.dart         # Modèle Question
│   │   ├── flashcard.dart        # Modèle Flashcard
│   │   └── quiz_result.dart      # Modèle Résultat
│   ├── services/                 # Logique métier
│   │   ├── data_service.dart     # Chargement YAML
│   │   ├── quiz_engine.dart      # Moteur de quiz
│   │   └── storage_service.dart  # Stockage local (Hive)
│   └── screens/                  # Interfaces utilisateur
│       ├── home_screen.dart      # Écran d'accueil
│       ├── quiz_screen.dart      # Écran Quiz
│       ├── flashcards_screen.dart # Écran Flashcards
│       └── progress_screen.dart  # Écran Progression
├── assets/
│   └── data/                     # Données YAML
│       └── user_management/      # Catégorie exemple
│           ├── questions.yaml    # 10 questions exemple
│           └── flashcards.yaml   # 10 flashcards exemple
└── pubspec.yaml                  # Configuration & dépendances
```

## 📝 Ajouter de Nouvelles Questions

Pour ajouter une nouvelle catégorie de questions :

1. **Créer un dossier** dans `assets/data/` :
   ```bash
   mkdir assets/data/ma_categorie
   ```

2. **Créer le fichier `questions.yaml`** :
   ```yaml
   - id: q001
     question: "Quelle est votre question ?"
     options:
       - "Réponse A"
       - "Réponse B"
       - "Réponse C"
       - "Réponse D"
     correct_answers: ["Réponse A"]
     explanation: "Explication détaillée de la réponse."
     hint: "Un indice pour aider"
     category: "ma_categorie"
     difficulty: "easy"
   ```

3. **Créer le fichier `flashcards.yaml`** :
   ```yaml
   - id: f001
     term: "Concept important"
     explanation: "Explication du concept"
     example: "Exemple concret"
     category: "ma_categorie"
   ```

4. **Mettre à jour la liste des catégories** dans `lib/services/data_service.dart` :
   ```dart
   static Future<List<String>> getAvailableCategories() async {
     return [
       'user_management',
       'filesystem',
       'networking',
       'security',
       'ma_categorie',  // ← Ajouter ici
     ];
   }
   ```

## 🎯 Utilisation de l'Application

### Démarrer un Quiz

1. Ouvrez l'app et restez sur l'onglet **Quiz**
2. Sélectionnez une **catégorie** (ex: User Management)
3. Choisissez le **nombre de questions** (10, 20, ou 40)
4. Appuyez sur **"Démarrer le Quiz"**
5. Répondez aux questions :
   - Sélectionnez une réponse
   - Cliquez sur **"Valider"**
   - Lisez l'explication
   - Passez à la **question suivante**
6. Consultez vos **résultats finaux**

### Consulter la Progression

1. Allez sur l'onglet **Progression**
2. Consultez vos statistiques :
   - Score moyen global
   - Meilleur score
   - Nombre de quiz complétés
   - Total de questions répondues
3. Parcourez l'historique de vos quiz

## 🔧 Dépendances Principales

- **flutter** : Framework UI
- **yaml** (^3.1.2) : Parser les fichiers YAML
- **hive** (^2.2.3) : Base de données locale NoSQL
- **hive_flutter** (^1.1.0) : Intégration Hive pour Flutter
- **path_provider** (^2.1.1) : Accès aux répertoires système
- **http** (^1.1.2) : Requêtes HTTP (pour futures mises à jour)
- **intl** (^0.19.0) : Internationalisation et formatage

## 🐛 Résolution de Problèmes

### L'app ne se lance pas
```bash
# Nettoyer le cache
~/flutter/bin/flutter clean
~/flutter/bin/flutter pub get
~/flutter/bin/flutter run
```

### Erreurs de compilation
```bash
# Regénérer les fichiers Hive
~/flutter/bin/dart run build_runner build --delete-conflicting-outputs
```

### Aucune question ne s'affiche
Vérifiez que les fichiers YAML sont bien dans `assets/data/` et que le chemin est correct dans `pubspec.yaml`.

## 📈 Prochaines Étapes

1. **Implémenter les Flashcards** : Interface de révision avec cartes retournables
2. **Système de marquage** : Sauvegarder questions/flashcards difficiles
3. **Mode examen** : Quiz chronométré sans feedback immédiat
4. **Mises à jour distantes** : Télécharger nouvelles questions depuis un serveur
5. **Multi-langues** : Support FR/EN/ES
6. **Thème sombre** : Mode sombre pour l'app
7. **Répétition espacée** : Algorithme Anki pour les flashcards

## 📄 Licence

Projet éducatif open-source.

---

**Développé avec ❤️ et Flutter**

