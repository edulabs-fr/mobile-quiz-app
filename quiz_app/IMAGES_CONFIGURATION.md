# 🎯 Système d'Images: Configuration complète

## 📋 Vue d'ensemble

```
SYSTÈME D'IMAGES (Local + Distantes)
│
├── Modèles (lib/models/)
│   ├── image_question.dart         [QuestionImage + ImageQuestion]
│   └── question.dart               [Question existant]
│
├── Composants UI (lib/widgets/)
│   ├── zoomable_image_viewer.dart  [ZoomableImageViewer + ImageGalleryWidget]
│   └── autres widgets...
│
├── Données (assets/)
│   ├── data/Réseaux/questions.yaml [Questions avec images]
│   └── images/                     [Images locales par catégorie]
│       ├── user_management/
│       ├── filesystem/
│       ├── service/
│       └── Réseaux/
│
└── Documentation
    ├── IMAGES_LOCAL_REMOTE.md
    ├── GUIDE_IMAGE_INTEGRATION.md
    ├── MIGRATION_ASSET_PATH_TO_SOURCE.md
    └── IMAGE_QUESTIONS_FORMAT.yaml
```

## 🔑 Caractéristiques principales

### 1. Détection automatique du type
```dart
// Source locale
"assets/images/Réseaux/diagram.png" → Local

// Source distante
"https://example.com/image.png" → Remote

// Détection auto avec isRemote property
image.isRemote  // true ou false
image.isLocal   // true ou false
```

### 2. Composants UI flexibles

**ZoomableImageViewer:**
- Pinch-to-zoom
- Double-tap zoom 3x
- Support local + remote
- Factory constructor pour auto-détection

**ImageGalleryWidget:**
- Galerie horizontale de miniatures
- Click pour voir en grand
- Dialog avec zoom complet
- Support mixed sources

### 3. Format YAML simplifié

```yaml
images:
  - id: "img_001"
    label: "Architecture réseau"
    source: "assets/images/Réseaux/diagram.png"  # ou URL
    description: "..."
```

## 🚀 Quick start

### 1. Créer les dossiers
```bash
mkdir -p assets/images/{user_management,filesystem,service,Réseaux}
```

### 2. Ajouter les images
```bash
# Copier images PNG/JPG dans les dossiers
cp /chemin/vers/images/*.png assets/images/Réseaux/
```

### 3. Déclarer dans pubspec.yaml
```yaml
assets:
  - assets/data/Réseaux/
  - assets/images/user_management/
  - assets/images/filesystem/
  - assets/images/service/
  - assets/images/Réseaux/
```

### 4. Ajouter au YAML de questions
```yaml
images:
  - source: "assets/images/Réseaux/diagram.png"
    label: "Diagramme"
```

### 5. Afficher dans QuizScreen
```dart
ImageGalleryWidget(
  images: question.images.map((img) => {
    'label': img.label,
    'source': img.source,
  }).toList(),
)
```

## 📊 Comparaison: Local vs Distant

| Aspect | Local | Distant |
|--------|-------|---------|
| Stockage | APK | Serveur web |
| APK size | +1-2 MB/image | Aucun impact |
| Vitesse | Très rapide | Dépend réseau |
| Offline | Fonctionne | Nécessite cache |
| Update | Rebuild APK | Immédiat |
| Sécurité | Complète | URL dépend serveur |

### Stratégie recommandée

```
Questions LOCALES:
- Diagrammes personnalisés
- Images critiques
- Assets stables

Questions DISTANTES:
- Références web
- Images volumineuses
- Ressources externes
```

## 🎨 Hiérarchie des classes

```
QuestionImage
├── id: String
├── label: String
├── source: String              (← URL ou assets/...)
├── description: String?
├── sourceType: String          (← "local" ou "remote")
├── isLocal: bool               (← Getter)
└── isRemote: bool              (← Getter)

ImageQuestion
├── id: String
├── question: String
├── images: List<QuestionImage> (← Peut mélanger local + remote)
├── options: List<String>
├── correctAnswers: List<String>
├── category: String
├── difficulty: String
└── ...autres champs
```

## 🔌 Intégration points

### Charger questions avec images
```dart
// Dans DataService ou QuizEngine
List<ImageQuestion> questions = 
    yaml.map((q) => ImageQuestion.fromYaml(q)).toList();
```

### Afficher galerie
```dart
ImageGalleryWidget(
  title: 'Images',
  images: currentQuestion.images.map((img) => {
    'id': img.id,
    'label': img.label,
    'source': img.source,
    'description': img.description,
  }).toList(),
)
```

### Gérer zoom
```dart
// Automatique via ZoomableImageViewer
// - Pinch to zoom: Gesture reconnaître
// - Double-tap: _handleDoubleTap() -> 3x scale
// - Limites: 0.5x à 4.0x
```

## 📱 Permissions (Android)

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
```

**Pourquoi:** Nécessaire pour charger images distantes (URLs HTTP/HTTPS)

## 🔄 Build commands

### Développement (Linux)
```bash
flutter run -d linux
```

### Build Hive adapters
```bash
flutter pub run build_runner build
```

### Build APK
```bash
flutter build apk --release
# Taille: ~20-25 MB (selon images locales)
```

## 🎯 Checklist d'intégration

Pour ajouter des questions avec images:

- [ ] Créer dossier `assets/images/CATEGORIE/`
- [ ] Placer images PNG/JPG
- [ ] Ajouter à `pubspec.yaml` sous `assets:`
- [ ] Écrire YAML avec format `source:` (pas `asset_path:`)
- [ ] Importer `ImageQuestion` dans loader
- [ ] Afficher via `ImageGalleryWidget`
- [ ] Tester images locales (flutter run)
- [ ] Tester images distantes (si URL valide)
- [ ] Rebuild APK si changement images locales
- [ ] Tester sur téléphone

## 🆘 Troubleshooting

### Images ne chargent pas
```
1. Vérifier chemin dans `source:`
2. Vérifier déclaration dans `pubspec.yaml`
3. Vérifier format: PNG, JPG, GIF
4. Vérifier permissions (Android)
```

### APK trop gros
```
1. Compresser images (imagemagick, etc.)
2. Utiliser images distantes
3. Réduire résolution (max 1024x768)
```

### Zoom ne fonctionne pas
```
1. InteractiveViewer peut être lent au chargement
2. Images distantes: attendre chargement complet
3. Vérifier format et codec image
```

### Erreur "source not found"
```
1. Vérifier URL (distant) est accessible
2. Vérifier chemin (local) exact
3. Vérifier encoding UTF-8 dans YAML
```

## 📚 Fichiers de référence

| Fichier | Contenu |
|---------|---------|
| `lib/models/image_question.dart` | Modèles Hive |
| `lib/widgets/zoomable_image_viewer.dart` | Composants UI |
| `assets/data/IMAGE_QUESTIONS_FORMAT.yaml` | Exemples YAML |
| `IMAGES_LOCAL_REMOTE.md` | Guide complet images |
| `GUIDE_IMAGE_INTEGRATION.md` | Intégration QuizScreen |
| `MIGRATION_ASSET_PATH_TO_SOURCE.md` | Migration format |

## 🌐 Resources externes

- [Flutter Image Widget](https://api.flutter.dev/flutter/widgets/Image-class.html)
- [Flutter InteractiveViewer](https://api.flutter.dev/flutter/widgets/InteractiveViewer-class.html)
- [YAML Format](https://yaml.org/)
- [HTTP Status Codes](https://httpwg.org/specs/rfc7231.html#status.codes)

## 📞 Contact support

Si vous avez des questions:
1. Vérifier la documentation
2. Consulter les exemples YAML
3. Checker les logs: `flutter run --verbose`
4. Vérifier les tests unitaires

---

**Dernière mise à jour:** 2025-01-09
**Version:** 1.0
**Statut:** ✅ Production-ready
