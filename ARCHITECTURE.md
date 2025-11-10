# 📐 ARCHITECTURE - Documentation Technique

**Pour les développeurs qui maintiennent le projet**

---

## 🏗️ Vue d'ensemble

### Stack Technologique
- **Framework**: Flutter (v3.24.5)
- **Langage**: Dart (v3.5.4)
- **Base de données locale**: Hive (NoSQL)
- **Sérialisation**: YAML (pour données catégories/questions)
- **État**: Hive + Provider (état persistant)

### Architecture générale
```
quiz_app/
├── lib/
│   ├── main.dart                    ← Point d'entrée
│   ├── models/                      ← Modèles Hive
│   ├── screens/                     ← Écrans Flutter
│   ├── services/                    ← Logique métier
│   ├── widgets/                     ← Composants réutilisables
│   └── utils/                       ← Utilitaires
├── assets/
│   ├── data/                        ← YAML catégories/questions
│   └── images/                      ← Images locales
└── pubspec.yaml                     ← Dépendances
```

---

## 🗂️ Modules Principaux

### 1. **Models** (`lib/models/`)
Définit la structure des données avec Hive pour persistence locale.

#### `question.dart` (typeId: 0)
```dart
@HiveType(typeId: 0)
class Question {
  String id;
  String question;
  List<String> options;
  List<String> correctAnswers;
  String explanation;
  String? hint;
  String category;
  String difficulty;  // 'facile', 'moyen', 'difficile'
  bool isMarked;
  String questionType;  // 'single' ou 'multiple'
  int points;
  List<String>? tags;
  String? reference;
  List<dynamic>? images;  // Maps du YAML avec source/label/description
}
```

**Fonctionnalités clés:**
- `fromYaml()` : Parse YAML → Question
- `isMultipleChoice` : Détecte les choix multiples
- `withShuffledOptions()` : Mélange les options

#### `quiz_result.dart` (typeId: 2)
```dart
@HiveType(typeId: 2)
class QuizResult {
  String id;
  DateTime date;
  String category;
  int questionsTotal;
  int correct;
  int incorrect;
  double averageTimePerQuestion;
  Map<String, dynamic> difficultyStats;  // Stats par difficulté
  List<String> difficultiesPresentes;
}
```

**Utilisé pour:** Tracker progression, statistiques

#### `image_question.dart` (typeId: 4-5)
```dart
@HiveType(typeId: 4)
class QuestionImage {
  String id;
  String label;
  String source;  // URL web OU chemin asset local
  String? description;
  String sourceType;  // 'local' ou 'remote' (auto-détecté)
}
```

**Fonctionnalités:**
- Auto-détection type image (http/https = remote)
- Gestion erreurs load images

---

### 2. **Services** (`lib/services/`)

#### `data_service.dart`
**Responsabilité:** Charger les catégories et questions depuis YAML

```dart
// Structure YAML attendue
assets/data/MaCategorie/
  ├── questions.yaml      ← Questions + images optionnelles
  ├── flashcards.yaml     ← Cartes mémorisation
  └── ...
```

**Fonctions clés:**
- `loadCategories()` : Retourne List<String> catégories
- `loadQuestions(category)` : Retourne List<Question>
- `loadFlashcards(category)` : Retourne List<Flashcard>

**Parsing YAML:**
```yaml
- id: question_001
  question: "Texte?"
  options: ["A", "B", "C"]
  correct_answers: ["A"]
  explanation: "..."
  category: MaCategorie
  difficulty: facile
  images:  # OPTIONNEL
    - id: img_1
      label: Mon Label
      source: "assets/images/MaCategorie/image.png"
      description: "Description"
```

#### `storage_service.dart`
**Responsabilité:** Persistence Hive + logique métier

**Hive Boxes:**
- `quiz_results` : Tous les QuizResult
- `marked_questions` : IDs questions marquées
- `failed_questions` : Questions échouées

**Fonctions clés:**
```dart
saveQuizResult(QuizResult)          // Enregistrer résultat quiz
getProgressByCategory()             // Stats par catégorie
getAverageScoreByDifficulty()       // Moyennes par difficulté
saveFailedQuestion(...)             // Enregistrer erreur
toggleMarkedQuestion(Question)      // Toggle signet
```

#### `quiz_engine.dart`
**Responsabilité:** Logique du quiz (correct/incorrect, temps, etc.)

```dart
class QuizEngine {
  List<Question> currentQuestions;
  int currentQuestionIndex;
  Map<String, bool> answerResults;
  Map<String, int> answerTime;
  
  // Méthodes clés
  bool checkAnswer(String answer)           // Valider réponse simple
  bool checkMultipleAnswers(List<String>)   // Valider choix multiples
  getProgress()                             // 0.0 à 1.0
  getAverageTimePerQuestion()               // Temps moyen
  isLastQuestion()                          // Vérifier fin
}
```

---

### 3. **Screens** (`lib/screens/`)

#### `quiz_screen.dart` (Écran principal quiz)
**Flow:**
1. User sélectionne catégories + nombre de questions
2. QuizEngine chargée avec questions
3. Questions affichées une par une
4. Réponse validée → résultat affiché
5. À la fin → enregistrement + stats

**État local:**
```dart
Set<String> selectedCategories;
int? selectedQuestionCount;
QuizEngine? quizEngine;
bool isQuizActive;
bool showResult;
bool? isCorrect;
List<dynamic> selectedAnswers;
```

**Images dans questions:**
```dart
// Si question.images != null
_buildImagesGallery(images)  // Boutons [Image 1] [Image 2]...
_showImageDialog(image)      // Full-screen viewer
```

**Révision (one-shot):**
- Passé via `revisionQuestions` parameter
- Ne sauvegarde PAS résultat
- Ne sauvegarde PAS questions échouées

#### `progress_screen.dart`
**Affiche:**
- Score total par catégorie
- Progression en %
- Stats par difficulté
- Graphiques

**Données sources:**
- `StorageService.getProgressByCategory()`
- `StorageService.getAverageScoreByDifficulty()`

#### `revision_screen.dart`
**Affiche:**
- Questions échouées par catégorie
- Bouton "Retester"
- Clique → `QuizScreen(revisionQuestions: failedQuestions)`

---

### 4. **Widgets** (`lib/widgets/`)

#### `zoomable_image_viewer.dart`
**Fonctionnalités:**
- Pinch-to-zoom (0.5x à 4.0x)
- Double-tap zoom 3x
- Image.asset ET Image.network
- Gestion erreurs + loading spinner
- Full-screen viewer

#### `image_gallery_widget.dart`
**Affiche:**
- Galerie miniatures cliquables
- Labels sous chaque image
- Full-screen au clic

---

## 🔄 Flows Principaux

### Flow 1: Quiz Normal
```
SelectCategoriesScreen
    ↓
QuizScreen (normal, quiz.revisionQuestions = null)
    ↓ Chaque question
    - Affiche question + options
    - Si images: affiche galerie boutons
    - User click image → _showImageDialog (fullscreen)
    - User répond
    ↓ Fin quiz
    - Enregistre QuizResult → Hive
    - Enregistre questions échouées
    - Affiche résultats
    ↓
ProgressScreen (mise à jour)
```

### Flow 2: Révision
```
ProgressScreen
    ↓ Click "Retester erreurs"
    - Charge failed_questions de Hive
    - Appelle QuizScreen(revisionQuestions: questions)
QuizScreen (revision, quiz.revisionQuestions != null)
    ↓ Chaque question
    - Même UI que normal
    - User répond
    ↓ Fin quiz
    - ❌ N'enregistre PAS QuizResult
    - ❌ N'enregistre PAS failed_questions
    - Affiche résultats
    ↓ Quitter
```

### Flow 3: Charger Questions
```
DataService.loadQuestions(category)
    ↓
assets/data/MaCategorie/questions.yaml
    ↓
YAML → Map<dynamic, dynamic> (via yaml package)
    ↓
Question.fromYaml(map)
    ├─ Parse question/options/correct_answers
    ├─ Parse images (si présentes)
    └─ Retourne Question
    ↓
QuizEngine initialized avec List<Question>
```

---

## 🎨 Images: Architecture

### Types support
1. **Local**: `assets/images/MaCategorie/file.png`
   - Image.asset()
   - Inclus dans APK
   - Rapide

2. **Web**: `https://example.com/image.png`
   - Image.network()
   - Téléchargé au runtime
   - Loading spinner

3. **Mixed**: Une question peut avoir local + web

### Flow images
```
Question.images (List<dynamic>)
    ↓ Map du YAML avec source/label/description
    ↓
_buildImagesGallery()
    ↓ Boutons [Image 1] [Image 2]...
    ↓ Au clic
    _showImageDialog(imageData)
        ├─ Détecte type (http? → remote : local)
        ├─ Image.network() OU Image.asset()
        ├─ Gestion erreurs
        └─ Full-screen Dialog
```

---

## 📦 Dépendances Clés

```yaml
flutter:
  sdk: flutter

hive: ^2.2.3                    # DB local
hive_flutter: ^1.1.0

yaml: ^3.1.2                    # Parser YAML
intl: ^0.19.0                   # Internationalisation
image: ^4.0.17                  # Traitement images
```

---

## 🔑 Points d'intégration critiques

### Ajouter une catégorie
1. Créer dossier `assets/data/MaCategorie/`
2. Ajouter `questions.yaml` + `flashcards.yaml`
3. Ajouter images dans `assets/images/MaCategorie/` (si besoin)
4. Déclarer dans `pubspec.yaml`:
   ```yaml
   assets:
     - assets/data/MaCategorie/
     - assets/images/MaCategorie/
   ```
5. Recompiler APK

### Modifier une question
1. Éditer `assets/data/MaCategorie/questions.yaml`
2. Hot-reload (dev) ou recompiler APK
3. Nouvelle version chargée au prochain app restart

### Ajouter images à une question
```yaml
- id: q_001
  question: "..."
  images:
    - id: img_1
      label: "Titre"
      source: "assets/images/MaCategorie/local.png"  # ou https://...
      description: "Description"
  options: [...]
```

---

## 🧪 Testing

### Build modes
```bash
flutter build apk --release        # Production
flutter build apk --debug          # Dev + logs
flutter run -d linux               # Linux simulator
```

### Nettoyer cache
```bash
flutter clean
rm -rf ~/.local/share/quiz_app     # Cache Hive
flutter pub get
flutter run -d linux
```

---

## 📊 Base de données (Hive)

### Boxes utilisés
```
~/.local/share/quiz_app/
├── quiz_results.hive              # QuizResult (typeId: 2)
├── marked_questions.hive          # Set<String> IDs
├── failed_questions.hive          # List<String> IDs
└── ...
```

### Initialisation
```dart
// main.dart
Hive.registerAdapter(QuestionAdapter());
Hive.registerAdapter(QuizResultAdapter());
// ... autres adapters
await Hive.openBox('quiz_results');
await Hive.openBox('marked_questions');
```

---

## 🚀 Déploiement

### Release APK
```bash
cd quiz_app
flutter pub get
flutter pub run build_runner build  # Générer .g.dart
flutter build apk --release
# APK: build/app/outputs/apk/release/app-release.apk
```

### Fichiers modifiés = rebuild
- YAML questions/catégories → reload (dev) ou rebuild APK
- Code Dart → rebuild APK
- Images PNG → rebuild APK

### Zero-rebuild pour
- Changer URLs web images
- Changer texte questions (sans changer structure YAML)

---

## 📝 Conventions

### IDs
- `question_xxx` : Questions
- `cat_xxx` : Catégories
- `img_xxx` : Images

### Difficultés
- `facile`
- `moyen`
- `difficile`

### Types questions
- `single` : Choix unique (radio button)
- `multiple` : Choix multiples (checkboxes)

---

## 🔗 Ressources Code

**Fichiers principaux à connaître:**
- `lib/main.dart` - Initialisation Hive
- `lib/services/storage_service.dart` - Cœur persistence
- `lib/services/quiz_engine.dart` - Logique quiz
- `lib/screens/quiz_screen.dart` - Écran quiz
- `assets/data/*/questions.yaml` - Données catégories

**Fichiers de config:**
- `pubspec.yaml` - Dépendances + assets
- `analysis_options.yaml` - Linting Dart

---

## ✅ Checklist Maintenance

- [ ] Code compile sans erreurs critiques
- [ ] Hive adapters générés (`flutter pub run build_runner build`)
- [ ] YAML valide (pas d'indentation issues)
- [ ] Images déclarées dans pubspec.yaml
- [ ] Cache Hive nettoyé avant test nouveau device
- [ ] Révisions ne sauvegardent pas progression
- [ ] Images local + web fonctionnent

---

**Dernière mise à jour:** 2025-11-10
**Maintainable par:** Developers Flutter/Dart
