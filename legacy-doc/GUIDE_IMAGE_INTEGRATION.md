# 🎯 Guide d'intégration: Questions avec Images dans QuizScreen

## 📌 Sommaire

1. Afficher les images dans les questions
2. Gérer le zoom et la galerie
3. Intégrer dans le flow de quiz
4. Tester et déployer

## 🔧 Intégration dans QuizScreen

### Étape 1: Importer les composants

```dart
// À ajouter en haut de lib/screens/quiz_screen.dart
import 'package:quiz_app/models/image_question.dart';
import 'package:quiz_app/widgets/zoomable_image_viewer.dart';
```

### Étape 2: Déterminer le type de question

```dart
// Dans la méthode _buildQuestionContent()
Widget _buildQuestionContent() {
  if (currentQuestion == null) return const SizedBox.shrink();

  // Vérifier si c'est une question avec images
  if (currentQuestion is ImageQuestion) {
    return _buildImageQuestionContent(currentQuestion as ImageQuestion);
  }
  
  // Sinon, afficher le format normal
  return _buildNormalQuestionContent();
}

Widget _buildImageQuestionContent(ImageQuestion imageQuestion) {
  return Column(
    children: [
      // Texte de la question
      Text(
        imageQuestion.question,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 16),
      
      // Galerie d'images
      ImageGalleryWidget(
        title: 'Images de la question',
        images: imageQuestion.images.map((img) {
          return {
            'id': img.id,
            'label': img.label,
            'source': img.source,
            'description': img.description,
            'isRemote': img.isRemote,
          };
        }).toList(),
      ),
      const SizedBox(height: 24),
      
      // Options de réponse
      _buildAnswerOptions(imageQuestion),
    ],
  );
}
```

### Étape 3: Afficher les options de réponse

```dart
Widget _buildAnswerOptions(ImageQuestion question) {
  return Column(
    children: question.options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isSelected = selectedAnswers.contains(option);
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedAnswers.remove(option);
                } else {
                  selectedAnswers.add(option);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? Colors.blue.withOpacity(0.1) : null,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedAnswers.add(option);
                        } else {
                          selectedAnswers.remove(option);
                        }
                      });
                    },
                  ),
                  Expanded(
                    child: Text(option),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}
```

### Étape 4: Valider la réponse

```dart
void _validateAnswer() {
  if (currentQuestion is ImageQuestion) {
    final imageQuestion = currentQuestion as ImageQuestion;
    
    // Vérifier si les réponses sélectionnées correspondent aux réponses correctes
    bool isCorrect = selectedAnswers.isNotEmpty &&
        selectedAnswers.length == imageQuestion.correctAnswers.length &&
        selectedAnswers.every((answer) => 
            imageQuestion.correctAnswers.contains(answer));
    
    // Enregistrer le résultat
    quizEngine!.answerQuestion(
      answer: selectedAnswers.toList(),
      isCorrect: isCorrect,
    );
    
    // Afficher le résultat
    setState(() {
      showResult = true;
    });
    
    // Auto-scroll à la correction (optionnel)
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollToCorrection();
    });
  }
}
```

## 🖼️ Support des images locales et distantes

### Gestion du cache

```dart
// Pour les images distantes, Flutter les cache automatiquement
// Pour force clear du cache:
imageCache.clear();
imageCache.clearLiveImages();
```

### Gestion des erreurs

```dart
// ImageGalleryWidget gère déjà les erreurs, mais vous pouvez ajouter:
try {
  // Vérifier la disponibilité des images avant de lancer le quiz
  for (var image in imageQuestion.images) {
    if (image.isRemote) {
      // Vérifier la connectivité (optionnel)
      // var connectivity = Connectivity().checkConnectivity();
    }
  }
} catch (e) {
  print('Erreur lors du chargement des images: $e');
}
```

## 🎨 Personnalisation UI

### Modifier la galerie

```dart
// Gallerie en grille au lieu de slider horizontal
class ImageGalleryWidgetGrid extends StatelessWidget {
  final List<Map<String, dynamic>> images;
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        // Construire les tuiles...
      },
    );
  }
}
```

### Ajouter des annotations

```dart
// Au-dessus de ImageGalleryWidget, ajouter:
if (imageQuestion.tags?.isNotEmpty ?? false)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Wrap(
      spacing: 8,
      children: imageQuestion.tags!.map((tag) {
        return Chip(
          label: Text(tag),
          backgroundColor: Colors.blue[100],
        );
      }).toList(),
    ),
  ),
```

## 🧪 Testing

### Tester images locales

```dart
// Dans _buildImageQuestionContent()
// Ajouter un bouton debug:
if (kDebugMode)
  ElevatedButton(
    onPressed: () {
      for (var image in imageQuestion.images) {
        print('Image: ${image.label}');
        print('Source: ${image.source}');
        print('Type: ${image.isRemote ? "remote" : "local"}');
      }
    },
    child: Text('Debug Images'),
  ),
```

### Tester images distantes

```bash
# Activer les logs réseau
flutter run --enable-logs=-all

# Vérifier les requêtes HTTP
# À chercher: "Image.network"
```

## 📦 Structure finale du widget

```dart
Column(
  children: [
    // 1. Titre de la question
    Text('Observez les images...'),
    
    // 2. Galerie d'images (local + remote mélangées)
    ImageGalleryWidget(
      images: [...],
    ),
    
    // 3. Options de réponse
    // (Checkbox, Radio, etc.)
    
    // 4. Bouton Valider
    ElevatedButton(
      onPressed: _validateAnswer,
      child: Text('Valider la réponse'),
    ),
    
    // 5. Résultat/Correction (si montré)
    if (showResult)
      _buildResultSection(),
  ],
)
```

## 🔄 Flux complet

```
1. Charger la question (ImageQuestion)
   ↓
2. Afficher la galerie avec miniatures
   ↓
3. User clique sur miniature → Dialog zoom
   ↓
4. User sélectionne réponse(s)
   ↓
5. Cliquer "Valider"
   ↓
6. Vérifier réponse
   ↓
7. Afficher résultat + correction
   ↓
8. Question suivante ou fin quiz
```

## 🚀 Build et déploiement

### Sur Linux (émulateur)

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
flutter run -d linux
```

### Sur Android (APK)

```bash
# Clean et rebuild
flutter clean
flutter pub get

# Si images locales, besoin de rebuild:
flutter pub run build_runner build

# Build APK
flutter build apk --release

# Installer
adb install -r build/app/outputs/flutter-app.apk
```

### Points importants

- ✅ Images distantes: Pas besoin de rebuild APK
- ⚠️ Images locales: Rebuild APK si fichiers changent
- 📦 APK size: ~20-25 MB avec quelques images
- 🌐 Internet permission: Nécessaire pour images distantes

## 🆘 Dépannage

| Problème | Solution |
|----------|----------|
| Images ne s'affichent pas | Vérifier `source:` dans YAML et `pubspec.yaml` |
| Crash au zoom | Vérifier format image, taille |
| Images distantes lentes | C'est normal, ajouter loader/spinner |
| APK trop gros | Compresser images ou utiliser distantes |

## 📝 Exemple complet

Voir fichier: `EXAMPLE_IMAGE_QUESTION_INTEGRATION.dart` (à créer)

## 📚 Références

- `IMAGES_LOCAL_REMOTE.md` - Guide images
- `lib/models/image_question.dart` - Modèle
- `lib/widgets/zoomable_image_viewer.dart` - Composants UI
- `assets/data/IMAGE_QUESTIONS_FORMAT.yaml` - Format YAML
