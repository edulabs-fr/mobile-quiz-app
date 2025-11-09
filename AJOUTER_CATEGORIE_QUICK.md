# ⚡ Ajouter une catégorie: Quick Reference

## 🚀 En 7 étapes

### 1️⃣ Dossiers
```bash
mkdir -p assets/data/MaCategorie
mkdir -p assets/images/MaCategorie  # Optionnel, si images locales
```

### 2️⃣ Fichiers YAML
```yaml
# assets/data/MaCategorie/questions.yaml
- id: "ma_q1"
  question: "Question ?"
  options: ["A", "B", "C", "D"]
  correct_answers: ["A"]
  explanation: "..."
  difficulty: "facile"

# assets/data/MaCategorie/flashcards.yaml
- id: "ma_f1"
  front: "Terme"
  back: "Définition"
  difficulty: "facile"
```

### 3️⃣ pubspec.yaml
```yaml
assets:
  - assets/data/MaCategorie/
  - assets/images/MaCategorie/  # Si images
```

### 4️⃣ lib/services/data_service.dart (Line ~89)
```dart
final List<String> allCategories = [
  'user_management',
  'filesystem',
  'service',
  'Réseaux',
  'MaCategorie',      # ← AJOUTER
];
```

### 5️⃣ Images (optionnel)
```yaml
# Dans questions.yaml
images:
  - id: "img_1"
    label: "Titre"
    source: "assets/images/MaCategorie/image.png"  # Local
    # OR
    source: "https://example.com/image.png"        # Web
    description: "..."
```

### 6️⃣ Placer les images
```bash
cp images/*.png assets/images/MaCategorie/
```

### 7️⃣ Relancer
```bash
R  # Hot restart
# ou
flutter clean && flutter run
```

---

## ⚠️ Points critiques

| Étape | Critique | Erreur si manquant |
|-------|----------|-------------------|
| pubspec.yaml `assets:` | ✅ VITAL | App crash ou fichier pas trouvé |
| data_service.dart `allCategories` | ✅ VITAL | Catégorie n'apparaît pas |
| questions.yaml | ✅ VITAL | Erreur YAML |
| flashcards.yaml | ✅ VITAL | Erreur YAML |
| images pubspec.yaml | ⚠️ Si images locales | Images ne chargent pas |
| images dossier | ⚠️ Si images locales | Images ne chargent pas |

---

## 🖼️ Avec images (exemple complet)

```yaml
# questions.yaml
- id: "ma_q1"
  question: "Quelle image ?"
  images:
    - id: "img_1"
      label: "Image A"
      source: "assets/images/MaCategorie/a.png"
      description: "Description A"
    - id: "img_2"
      label: "Image B (web)"
      source: "https://example.com/b.png"
      description: "Description B"
  options: ["Image A", "Image B"]
  correct_answers: ["Image A"]
  explanation: "..."
  difficulty: "facile"
```

---

## ✅ Vérifier

```bash
# 1. Catégorie apparaît dans Quiz
flutter run

# 2. Cliquer sur catégorie → voir questions
# 3. Si images → voir miniatures et zoom

# 4. Catégorie apparaît dans Flashcards
# 5. Tester une flashcard
```

---

## 📚 Documentation complète

- `AJOUTER_CATEGORIE.md` - Guide détaillé (ce document)
- `IMAGES_LOCAL_REMOTE.md` - Guide images (local + web)
- `README_IMAGES.md` - Quick start images
- `GUIDE_IMAGE_INTEGRATION.md` - Intégration technique

---

**Durée moyenne: 10-15 minutes (sans images) / 20-30 minutes (avec images)**
