# 🖼️ Système d'Images: Local & Distantes

## 📋 Vue d'ensemble

L'application supporte maintenant **deux modes d'images**:
- 🎯 **Images locales** : Stockées dans `assets/images/`
- 🌐 **Images distantes** : URLs HTTP/HTTPS (depuis un serveur web)

## 🗂️ Structure des dossiers d'images

```
assets/images/
├── user_management/        # Images pour la catégorie "user_management"
│   ├── user_permissions.png
│   ├── sudo_diagram.png
│   └── ...
├── filesystem/             # Images pour la catégorie "filesystem"
│   ├── inode_structure.png
│   ├── directory_tree.png
│   └── ...
├── service/                # Images pour la catégorie "service"
│   ├── systemd_architecture.png
│   ├── daemon_process.png
│   └── ...
└── Réseaux/                # Images pour la catégorie "Réseaux"
    ├── network_star.png
    ├── network_bus.png
    ├── osi_model.png
    └── ...
```

**🎨 Recommandations:**
- Format: PNG ou JPG
- Taille: Max 2MB par image (pour performance)
- Résolution: 800x600px minimum (pour lisibilité)
- Ratio: 4:3 ou 16:9 recommandé

## 📝 Format YAML - Images locales

```yaml
- id: "img_q001"
  question: "Observez le schéma ci-dessous..."
  images:
    - id: "img_001_1"
      label: "Architecture Étoile"
      source: "assets/images/Réseaux/network_star.png"  # ← Image locale
      description: "Description pour l'accessibilité"
    
    - id: "img_001_2"
      label: "Architecture Bus"
      source: "assets/images/Réseaux/network_bus.png"   # ← Image locale
      description: "Autre description"
  
  options: ["Étoile", "Bus", "Maille", "Anneau"]
  correct_answers: ["Étoile"]
  category: "Réseaux"
  difficulty: "facile"
```

## 🌐 Format YAML - Images distantes (URLs)

```yaml
- id: "img_q002"
  question: "Examinez l'architecture réseau..."
  images:
    - id: "img_002_1"
      label: "Modèle OSI depuis Wikipédia"
      source: "https://www.museeinformatique.fr/wp-content/uploads/2022/07/réseau-informatique-1-1024x683.jpg"
      description: "Illustration du modèle OSI complet"
    
    - id: "img_002_2"
      label: "Topologies réseau"
      source: "https://example.com/network-topologies.png"
      description: "Comparaison des différentes topologies"
  
  options: ["Topologie 1", "Topologie 2"]
  correct_answers: ["Topologie 1"]
  category: "Réseaux"
  difficulty: "moyen"
```

## 🔄 Format YAML - Mélange (local + distantes)

```yaml
- id: "img_q003"
  question: "Comparez les architectures..."
  images:
    # Image locale
    - id: "img_003_1"
      label: "Diagramme local"
      source: "assets/images/Réseaux/architecture_diagram.png"
      description: "Notre diagramme personnalisé"
    
    # Image distante
    - id: "img_003_2"
      label: "Référence officielle"
      source: "https://example.com/official-diagram.png"
      description: "Diagramme officiel du protocole"
  
  options: ["Correcte", "Incorrecte"]
  correct_answers: ["Correcte"]
  category: "Réseaux"
  difficulty: "difficile"
```

## 🎯 Détection automatique du type

Le système détecte **automatiquement** le type de source:

```dart
// Détection automatique dans QuestionImage
final source = "https://example.com/image.png";
final isRemote = source.startsWith('http://') || source.startsWith('https://');
// isRemote = true

final source2 = "assets/images/Réseaux/diagram.png";
final isRemote2 = source2.startsWith('http://') || source2.startsWith('https://');
// isRemote2 = false
```

## 🔧 Modèle Dart - QuestionImage

```dart
class QuestionImage {
  final String id;
  final String label;
  final String source;        // ← URL ou chemin asset
  final String? description;
  final String sourceType;    // "local" ou "remote"

  bool get isLocal => sourceType == 'local';
  bool get isRemote => sourceType == 'remote';
}

class ImageQuestion {
  final String id;
  final String question;
  final List<QuestionImage> images;  // ← Peut mélanger local + remote
  final List<String> options;
  final List<String> correctAnswers;
  // ... autres champs
}
```

## 🎨 Composants UI

### ZoomableImageViewer

Affiche une image avec zoom:
- Pinch-to-zoom (geste)
- Double-tap pour zoom 3x
- Support local ET distantes

```dart
// Image locale
ZoomableImageViewer(
  imageSource: "assets/images/diagram.png",
  label: "Diagramme",
  isRemote: false,
)

// Image distante
ZoomableImageViewer(
  imageSource: "https://example.com/image.png",
  label: "Reference",
  isRemote: true,
)

// Détection automatique
ZoomableImageViewer.auto(
  source: imageSource,  // Auto-détecte le type
  label: "Image",
)
```

### ImageGalleryWidget

Galerie de miniatures cliquables:
- Défilement horizontal
- Click pour agrandir en dialog
- Support local ET distantes

```dart
ImageGalleryWidget(
  title: 'Architectures Réseau',
  images: [
    {
      'label': 'Bus',
      'source': 'assets/images/Réseaux/network_bus.png',
      'description': 'Architecture Bus...'
    },
    {
      'label': 'Étoile (web)',
      'source': 'https://example.com/network_star.png',
      'description': 'Architecture Étoile...'
    },
  ],
)
```

## ⚙️ Configuration - pubspec.yaml

Les images locales doivent être déclarées dans `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/data/user_management/
    - assets/data/filesystem/
    - assets/data/service/
    - assets/data/Réseaux/
    # Images associées
    - assets/images/user_management/
    - assets/images/filesystem/
    - assets/images/service/
    - assets/images/Réseaux/
```

## 🌐 Considérations réseau

### Images distantes (URLs HTTP/HTTPS)

**Avantages:**
- ✅ Pas d'ajout d'espace sur l'APK
- ✅ Mises à jour sans rebuild
- ✅ Partage de ressources centralisées

**Limitations:**
- ⚠️ Nécessite connexion internet
- ⚠️ Plus lent que local
- ⚠️ Dépend de disponibilité du serveur

**Configuration (Android):**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
```

## 🔐 Sécurité

**Images distantes - Points importants:**
1. Valider les URL (HTTPS préféré)
2. Timeout: 30 secondes par défaut
3. Gestion des erreurs avec message clair
4. Fallback: Icône d'erreur si chargement échoue

**Images locales - Points importants:**
1. Inclure dans `pubspec.yaml`
2. Vérifier le chemin exact
3. Format supporté: PNG, JPG, GIF

## 📋 Checklist - Ajouter des images à une catégorie

- [ ] Créer dossier `assets/images/CATEGORIE/`
- [ ] Placer les images PNG/JPG
- [ ] Ajouter à `pubspec.yaml` sous `assets:`
- [ ] Dans YAML questions:
  - [ ] Utiliser `source:` (au lieu de `asset_path:`)
  - [ ] Ajouter `label:` pour la description
  - [ ] Ajouter `description:` pour l'accessibilité
- [ ] Tester sur émulateur Linux
- [ ] Vérifier dimensions et qualité
- [ ] Rebuild APK si images locales

## 🧪 Test

### Tester images locales
```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
flutter run -d linux
# Vérifier que les images s'affichent
# Essayer pinch-to-zoom et double-tap
```

### Tester images distantes
```dart
// Dans ImageGalleryWidget
images: [
  {
    'source': 'https://www.museeinformatique.fr/wp-content/uploads/2022/07/réseau-informatique-1-1024x683.jpg',
    'label': 'Test URL distante',
  }
]
```

## 📚 Exemples complets

Voir: `assets/data/IMAGE_QUESTIONS_FORMAT.yaml`

## 🆘 Dépannage

| Problème | Solution |
|----------|----------|
| Image locale non trouvée | Vérifier chemin dans `source:` et dans `pubspec.yaml` |
| Image distante ne charge pas | Vérifier URL, connexion internet, serveur accessible |
| Zoom ne marche pas | Images distantes: peut être lent au premier chargement |
| APK trop gros | Utiliser images distantes ou compresser images locales |
| Erreur "Source not supported" | Vérifier format: PNG, JPG, GIF supportés |

## 📞 Liens utiles

- [Flutter Image Widget](https://api.flutter.dev/flutter/widgets/Image-class.html)
- [Flutter Image.network](https://api.flutter.dev/flutter/widgets/Image/Image.network.html)
- [Flutter InteractiveViewer](https://api.flutter.dev/flutter/widgets/InteractiveViewer-class.html)
