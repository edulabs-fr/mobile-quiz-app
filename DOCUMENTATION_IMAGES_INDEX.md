# 📚 Index complet: Système d'Images (Local + Distantes)

## 📖 Documentation par niveau

### 🚀 Je veux commencer rapidement
**→ Lire:** `AJOUTER_CATEGORIE_QUICK.md`
- 7 étapes simples
- Exemples concis
- ~5 min de lecture

### 📘 Je veux le guide complet d'une catégorie
**→ Lire:** `AJOUTER_CATEGORIE.md`
- Procédure détaillée step-by-step
- Exemples complets (DevOps, Réseaux)
- Troubleshooting détaillé
- ~30 min de lecture

### 🖼️ Je veux comprendre les images
**→ Lire:** `IMAGES_LOCAL_REMOTE.md`
- Images locales vs distantes
- Structure des dossiers
- Format YAML détaillé
- Sécurité et permissions
- ~20 min de lecture

### ⚡ Je veux juste les images (TL;DR)
**→ Lire:** `README_IMAGES.md`
- 3 exemples YAML rapides
- Fonctionnalités principales
- FAQ courtes
- ~5 min de lecture

### 🛠️ Je suis développeur (intégration technique)
**→ Lire:** `GUIDE_IMAGE_INTEGRATION.md`
- Intégration dans QuizScreen
- Code Dart complet
- Personnalisation UI
- Testing
- ~30 min de lecture

### ⚙️ Je veux la configuration globale
**→ Lire:** `IMAGES_CONFIGURATION.md`
- Architecture système
- Modèles Dart (QuestionImage, ImageQuestion)
- Composants UI (ZoomableImageViewer, ImageGalleryWidget)
- Checklist d'intégration
- ~20 min de lecture

### 🔄 Je dois migrer du format ancien
**→ Lire:** `MIGRATION_ASSET_PATH_TO_SOURCE.md`
- Ancien format: `asset_path:`
- Nouveau format: `source:`
- Rétrocompatibilité
- Exemples de migration
- ~10 min de lecture

### 📋 Je veux des exemples YAML
**→ Voir:** `assets/data/IMAGE_QUESTIONS_FORMAT.yaml`
- 2 questions complètes avec images
- Images locales ET distantes
- Format de référence
- Copy-paste ready

---

## 🎯 Workflows courants

### Workflow 1: Créer une nouvelle catégorie SANS images
```
1. Lire: AJOUTER_CATEGORIE_QUICK.md (5 min)
2. Créer dossiers et fichiers
3. Ajouter pubspec.yaml
4. Ajouter data_service.dart
5. Test: flutter run
⏱️ Temps total: ~15 min
```

### Workflow 2: Créer une catégorie AVEC images locales
```
1. Lire: AJOUTER_CATEGORIE_QUICK.md (5 min)
2. Lire: README_IMAGES.md (5 min)
3. Créer dossiers et fichiers
4. Préparer images (PNG/JPG, 800x600px)
5. Ajouter pubspec.yaml (data + images)
6. Ajouter questions YAML avec images
7. Ajouter data_service.dart
8. Test: flutter run
⏱️ Temps total: ~30 min
```

### Workflow 3: Créer une catégorie AVEC images web (distantes)
```
1. Lire: AJOUTER_CATEGORIE_QUICK.md (5 min)
2. Lire: README_IMAGES.md (5 min)
3. Créer dossiers et fichiers
4. Ajouter pubspec.yaml (data + images)
5. Ajouter questions YAML avec URLs
6. Ajouter data_service.dart
7. Test: flutter run
⏱️ Temps total: ~15 min (pas besoin de préparer images)
```

### Workflow 4: Mélanger images locales ET web dans une catégorie
```
1. Lire: AJOUTER_CATEGORIE_QUICK.md (5 min)
2. Lire: README_IMAGES.md (5 min)
3. Lire: IMAGES_LOCAL_REMOTE.md section "Mélange" (5 min)
4. Créer dossiers et fichiers
5. Préparer images locales
6. Ajouter pubspec.yaml (data + images)
7. Ajouter questions YAML (sources mixtes)
8. Ajouter data_service.dart
9. Test: flutter run
⏱️ Temps total: ~30 min
```

### Workflow 5: Migrer catégorie existante avec ancien format
```
1. Lire: MIGRATION_ASSET_PATH_TO_SOURCE.md (10 min)
2. Ouvrir questions.yaml
3. Remplacer asset_path: par source:
4. Optionnel: ajouter images web
5. Test: flutter run
⏱️ Temps total: ~20 min
```

---

## 📊 Decision Tree (Quel doc lire ?)

```
"Je dois ajouter une catégorie"
├─ "Je suis pressé"
│  └─→ AJOUTER_CATEGORIE_QUICK.md
├─ "Je veux tous les détails"
│  └─→ AJOUTER_CATEGORIE.md
└─ "J'ai des questions"
   ├─ "Sur les images"
   │  ├─ "Quick info"
   │  │  └─→ README_IMAGES.md
   │  ├─ "Guide complet"
   │  │  └─→ IMAGES_LOCAL_REMOTE.md
   │  └─ "Code et tech"
   │     └─→ GUIDE_IMAGE_INTEGRATION.md
   ├─ "Sur l'architecture"
   │  └─→ IMAGES_CONFIGURATION.md
   └─ "Je dois migrer"
      └─→ MIGRATION_ASSET_PATH_TO_SOURCE.md
```

---

## 📝 Fichiers sources

| Fichier | Contenu | À lire |
|---------|---------|--------|
| `AJOUTER_CATEGORIE.md` | Guide complet pour ajouter catégorie | Tous |
| `AJOUTER_CATEGORIE_QUICK.md` | 7 étapes rapides | Pressés |
| `README_IMAGES.md` | Quick start images | Impatients |
| `IMAGES_LOCAL_REMOTE.md` | Guide détaillé images | Curieux |
| `IMAGES_CONFIGURATION.md` | Architecture système | Devs |
| `GUIDE_IMAGE_INTEGRATION.md` | Intégration QuizScreen | Devs |
| `MIGRATION_ASSET_PATH_TO_SOURCE.md` | Migrer format ancien | Si existant |
| `assets/data/IMAGE_QUESTIONS_FORMAT.yaml` | Exemples YAML | Tous |

---

## 🗂️ Fichiers de code

| Fichier | Rôle |
|---------|------|
| `lib/models/image_question.dart` | Modèles Hive (QuestionImage, ImageQuestion) |
| `lib/widgets/zoomable_image_viewer.dart` | UI: ZoomableImageViewer, ImageGalleryWidget |
| `pubspec.yaml` | Déclaration assets (data + images) |
| `lib/services/data_service.dart` | Déclaration catégories (allCategories list) |

---

## ⏱️ Durée estimée par tâche

| Tâche | Durée (sans exp) | Durée (avec exp) |
|-------|------------------|------------------|
| Lire documentation | 20-40 min | 5-10 min |
| Créer catégorie simple | 15 min | 5 min |
| Créer catégorie + images locales | 30 min | 10 min |
| Créer catégorie + images web | 20 min | 5 min |
| Créer catégorie + mixed images | 30 min | 10 min |
| Troubleshooting (pire cas) | 45 min | 15 min |
| **TOTAL MOYEN** | **~1h** | **~15-20 min** |

---

## ✅ Checklist d'avant-garde

Avant de commencer, assurez-vous que:
- [ ] Code Flutter compilé et testé ✓
- [ ] Vous avez des images (PNG/JPG) OU URLs web
- [ ] Vous savez le nom de votre catégorie
- [ ] Vous avez au moins 5 questions et 5 flashcards

---

## 🆘 En cas de problème

### Cherchez d'abord:
1. `AJOUTER_CATEGORIE.md` → Section "❌ Problèmes courants"
2. `README_IMAGES.md` → Section "❓ FAQ"
3. `IMAGES_LOCAL_REMOTE.md` → Section "🆘 Dépannage"

### Si toujours pas résolu:
1. Vérifiez les logs: `flutter run --verbose`
2. Essayez: `flutter clean && flutter pub get && flutter run`
3. Vérifiez YAML: indentation, tirets, guillemets

---

## 🎓 Concepts clés

- **Catégorie** : Dossier dans `assets/data/` avec questions.yaml + flashcards.yaml
- **Images locales** : Fichiers PNG/JPG dans `assets/images/CATEGORIE/`
- **Images distantes** : URLs HTTP/HTTPS vers serveurs externes
- **Source** : Nouveau champ YAML qui accepte local OU web
- **Auto-detect** : Système détecte type basé sur URL (http:// = web)
- **pubspec.yaml** : VITAL pour charger les assets
- **data_service.dart** : VITAL pour afficher la catégorie dans l'app

---

**Dernière mise à jour:** 2025-01-09
**Version:** 1.0
**Statut:** Production-ready
