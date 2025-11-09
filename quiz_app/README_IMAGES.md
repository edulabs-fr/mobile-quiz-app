# 🖼️ Images dans Quiz App

## ⚡ TL;DR - Pour utiliser les images

### 1️⃣ Créer une question avec images locales

```yaml
- id: "img_q001"
  question: "Quel est le type d'architecture ?"
  images:
    - id: "img_001_1"
      label: "Architecture Étoile"
      source: "assets/images/Réseaux/network_star.png"  # ← Image locale
      description: "Description"
    - id: "img_001_2"
      label: "Architecture Bus"
      source: "assets/images/Réseaux/network_bus.png"   # ← Image locale
      description: "Description"
  options: ["Étoile", "Bus", "Maille"]
  correct_answers: ["Étoile"]
  category: "Réseaux"
  difficulty: "facile"
```

### 2️⃣ Utiliser des images distantes (web)

```yaml
- id: "img_q002"
  question: "Identifiez le modèle OSI"
  images:
    - id: "img_002_1"
      label: "Modèle OSI"
      source: "https://example.com/osi-model.png"  # ← Image depuis le web
      description: "Modèle OSI complet"
  options: ["7 couches", "5 couches"]
  correct_answers: ["7 couches"]
  category: "Réseaux"
  difficulty: "moyen"
```

### 3️⃣ Mélanger local + web

```yaml
- id: "img_q003"
  question: "Comparez..."
  images:
    - id: "img_003_1"
      source: "assets/images/Réseaux/diagram.png"  # Local
    - id: "img_003_2"
      source: "https://example.com/reference.png"  # Web
  options: ["Option 1", "Option 2"]
  correct_answers: ["Option 1"]
```

## 📁 Structure des images

```
assets/images/
├── Réseaux/
│   ├── network_star.png
│   ├── network_bus.png
│   └── osi_model.png
├── filesystem/
├── user_management/
└── service/
```

## 🚀 Étapes rapides

1. **Ajouter image locale:**
   - Copier fichier dans `assets/images/CATEGORIE/`
   - Écrire YAML avec `source: "assets/images/..."`
   - Vérifier dans `pubspec.yaml` assets

2. **Ajouter image web:**
   - Écrire YAML avec `source: "https://..."`
   - C'est tout! (pas besoin de rebuild APK)

3. **Tester:**
   ```bash
   flutter run -d linux
   ```

## ✨ Fonctionnalités

- ✅ **Pinch-to-zoom**: Geste pour zoomer les images
- ✅ **Double-tap**: Double-tap pour zoom 3x
- ✅ **Galerie**: Miniatures cliquables
- ✅ **Full-screen**: Click miniature pour voir en grand
- ✅ **Local + Web**: Mélanger images locales et distantes
- ✅ **Auto-detect**: Détection auto du type (local/web)

## 📖 Documentation complète

- 📖 **IMAGES_LOCAL_REMOTE.md** - Guide détaillé
- 📖 **GUIDE_IMAGE_INTEGRATION.md** - Intégration dans QuizScreen
- 📖 **IMAGES_CONFIGURATION.md** - Configuration système
- 📖 **IMAGE_QUESTIONS_FORMAT.yaml** - Exemples YAML

## 🔗 Liens utiles

```
assets/data/IMAGE_QUESTIONS_FORMAT.yaml  ← Voir exemples
lib/models/image_question.dart           ← Modèles Dart
lib/widgets/zoomable_image_viewer.dart   ← Composants UI
```

## ❓ FAQ

**Q: Comment ajouter une image locale?**
A: `source: "assets/images/Réseaux/nom_fichier.png"`

**Q: Comment ajouter une image web?**
A: `source: "https://example.com/image.png"`

**Q: Faire zoom sur image?**
A: Pinch-to-zoom ou double-tap automatiquement

**Q: APK devient trop gros?**
A: Utiliser images web au lieu de local, ou compresser images

**Q: Image ne charge pas?**
A: Vérifier chemin/URL et permission internet (Android)

---

**Plus de détails:** Voir documentation complète en haut du dossier
