# 📝 CHANGELOG - Historique des versions

**Suivi des mises à jour et changements significatifs**

---

## 🎉 [2025-11-10] - Documentation Consolidation

### ✨ Ajouts

#### Nouvelle documentation
- ✅ **ARCHITECTURE.md** - Guide technique pour développeurs (154 lignes)
- ✅ **ADMIN_GUIDE.md** - Guide administrateur pour créer/modifier contenu (378 lignes)
- ✅ **USER_GUIDE.md** - Guide utilisateur pour utiliser l'app (298 lignes)
- ✅ **INDEX.md** - Index de navigation centrale
- ✅ **ONBOARDING.md** - Guide onboarding par étapes
- ✅ **QUICK_START.md** - TL;DR rapide pour chaque rôle
- ✅ **CONSOLIDATION_SUMMARY.md** - Résumé de la consolidation
- ✅ **CHANGELOG.md** - Ce fichier

#### Améliorations README.md
- Refactorisé de 2 lignes → 250 lignes complètes
- Ajout liens rapides vers QUICK_START/ONBOARDING
- Ajout architecture overview
- Ajout workflows complets (dev, admin)
- Ajout technologie stack
- Ajout troubleshooting

### 🗂️ Changements organisationnels

#### Archivage
- ✅ Créé dossier `legacy-doc/`
- ✅ Archivé 21 anciens fichiers documentation
- ✅ Préservé contenu pour référence historique

#### Fichiers archivés
- AJOUTER_CATEGORIE.md (remplacé par ADMIN_GUIDE.md)
- AJOUTER_CATEGORIE_QUICK.md (remplacé par ADMIN_GUIDE.md)
- CHANGEMENTS_VISUELS.txt (contexte historique)
- DOCUMENTATION_IMAGES_INDEX.md (mergé dans ADMIN_GUIDE.md)
- FILES_TO_READ.md (remplacé par INDEX.md)
- FORMAT_YAML.md (mergé dans ADMIN_GUIDE.md)
- GUIDE_BRANDING.md (archivé)
- GUIDE_EXTENSION.md (historique)
- GUIDE_IMAGE_INTEGRATION.md (mergé dans ADMIN_GUIDE.md)
- GUIDE_TEST_APK.md (mergé dans ARCHITECTURE.md)
- IMAGES_CONFIGURATION.md (mergé dans ADMIN_GUIDE.md)
- IMAGES_LOCAL_REMOTE.md (mergé dans ADMIN_GUIDE.md)
- IMPLEMENTATION_SUMMARY.md (historique)
- MIGRATION_ASSET_PATH_TO_SOURCE.md (historique)
- RESOLUTION_DEUX_PROBLEMES.md (historique)
- RESUM_IMAGES_TEST.txt (historique)
- SYSTEM_SUMMARY.txt (historique)
- TEST_IMAGES_SETUP.md (historique)
- TEST_NOW.md (ad-hoc)
- TEST_PHONE.md (historique)
- WHAT_HAS_BEEN_DONE.md (historique)

### 📊 Statistiques

| Métrique | Avant | Après | Changement |
|----------|-------|-------|-----------|
| Fichiers root | 20 | 10 | -50% ✅ |
| Audience définie | Non | Oui (3) | +Clarté |
| Index/Navigation | Non | Oui | ✅ |
| Duplication content | Élevée | Minimale | ✅ |
| Onboarding time | ~2h | ~20-30 min | -75% ✅ |

### 🎯 Résultat

```
ROOT DIRECTORY (10 fichiers):
  📄 README.md                  ← Intro clara + liens
  📄 QUICK_START.md             ← 5 min per rôle
  📄 ONBOARDING.md              ← Guided setup
  📄 INDEX.md                   ← Navigation
  📘 ARCHITECTURE.md            ← Dev guide
  📗 ADMIN_GUIDE.md             ← Admin guide
  📕 USER_GUIDE.md              ← User guide
  📙 CONSOLIDATION_SUMMARY.md   ← Summary
  📄 doc.md                     ← Legacy
  📄 hello.txt                  ← Legacy

ARCHIVE (legacy-doc/): 21 fichiers
```

---

## 📌 [2025-11-09] - Bug Fixes Session

### 🐛 Fixes

#### Révision Quiz (one-shot mode)
- ✅ Revision quizzes ne sauvegardent plus les résultats
- ✅ Revision quizzes ne mettent plus à jour la progression
- ✅ Passage via `widget.revisionQuestions` parameter

#### Map Type Casting Bug
- ✅ Fixed: `StorageService.getAverageScoreByDifficulty()` line 125
- ✅ Changé: Direct cast → safe pattern avec `if (stats is Map)`
- ✅ Resolved: "'_Map<dynamic, dynamic>' is not a subtype" error

#### Image Display Bug
- ✅ Fixed: Image buttons showing but dialog not displaying
- ✅ Cause 1: Type mismatch accessing `.label` on Map
- ✅ Cause 2: Dialog layout (Column mainAxisSize.min)
- ✅ Solution: Safe Map access + SizedBox + Expanded layout

### 📝 Code Changes

#### `lib/screens/quiz_screen.dart`
- Added: `_buildImagesGallery()` method (~50 lines)
- Added: `_showImageDialog()` method (~130 lines)
- Modified: Image button rendering (safe Map access)
- Modified: Dialog layout (SizedBox + Expanded)
- Modified: Result saving (conditional on `!isRevision`)

#### `lib/models/question.dart`
- Changed: `List<QuestionImage>?` → `List<dynamic>?`
- Modified: `fromYaml()` to keep raw Maps
- Modified: `copyWith()` parameter types

#### `lib/services/storage_service.dart`
- Modified: Line 125 type-safe Map extraction

#### `assets/data/Réseaux/questions.yaml`
- Added: Test question `net_q_img_001` with 3 images

#### `assets/images/Réseaux/`
- Created: `network_bus.png` (3.2K)
- Created: `network_star.png` (4.2K)

### ✅ Testing

- ✅ App compiles without errors
- ✅ App launches successfully
- ✅ Quiz functionality works
- ✅ Image display works
- ✅ Progress tracking works (revision excluded)

---

## 🎨 [2025-11-08] - Image Integration

### ✨ Ajouts

#### Image Support
- ✅ Integrated images into questions
- ✅ Display as clickable buttons in quiz
- ✅ Fullscreen viewer on click
- ✅ Support local (PNG) + remote (HTTPS URLs)
- ✅ Zoom/pinch functionality
- ✅ Image gallery widget

#### Models
- ✅ Added `List<dynamic>? images` to Question model
- ✅ Images stored as Maps from YAML (not objects)
- ✅ Support for image metadata (label, description)

#### UI Components
- ✅ `_buildImagesGallery()` for image button display
- ✅ `_showImageDialog()` for fullscreen viewer
- ✅ Image loading spinner + error handling

#### Test Data
- ✅ Added test question with 3 images
- ✅ Created test PNG images

### 📝 Code

#### `lib/screens/quiz_screen.dart`
- New: Image gallery button rendering
- New: Fullscreen dialog with zoom support
- New: Image handling (local vs remote)

#### `pubspec.yaml`
- Added: `image` package for image handling
- Added: `assets/images/` declaration

---

## 🔄 [2025-11-07] - Quiz Revision Feature

### ✨ Ajouts

#### Revision Quiz Mode
- ✅ Implemented one-shot revision quizzes
- ✅ Revision questions don't count toward progression
- ✅ Quick retesting of failed questions
- ✅ Access from progress screen or after quiz

### 📝 Code Changes

#### `lib/screens/quiz_screen.dart`
- Added: `revisionQuestions` parameter
- Added: Conditional result saving (skip if revision)
- Added: Revision mode indicator

#### `lib/screens/progress_screen.dart`
- Added: "Revise errors" button
- New: Failed questions retrieval from storage

---

## 📊 [2025-11-06] - Progress Tracking & Statistics

### ✨ Ajouts

#### Progress Features
- ✅ Implemented QuizResult storage
- ✅ Score calculation by category
- ✅ Statistics by difficulty level
- ✅ Average time per question
- ✅ Historical tracking

### 📝 Code Changes

#### `lib/models/quiz_result.dart`
- New: QuizResult Hive model
- Includes: difficulty stats, category, dates

#### `lib/services/storage_service.dart`
- New: `saveQuizResult()` method
- New: `getProgressByCategory()` method
- New: `getAverageScoreByDifficulty()` method
- New: Failed questions tracking

#### `lib/screens/progress_screen.dart`
- New: Statistics display with graphs
- New: Filter by difficulty
- New: Progress trends

---

## 🎮 [2025-11-05] - Core Quiz Engine

### ✨ Ajouts

#### Quiz Features
- ✅ Implemented QuizEngine logic
- ✅ Support for single + multiple choice
- ✅ Answer validation
- ✅ Time tracking per question
- ✅ Score calculation

### 📝 Code Changes

#### `lib/services/quiz_engine.dart`
- New: QuizEngine class with core logic
- Methods: checkAnswer, getProgress, getScore
- Support: Single & multiple choice validation

#### `lib/screens/quiz_screen.dart`
- New: Main quiz interface
- Question display & answer input
- Result feedback
- Navigation between questions

#### `assets/data/` Structure
- Created: YAML format for questions
- Categories: Réseaux, Sécurité, etc.

---

## 🏗️ [2025-10-31] - Project Initialization

### ✨ Création

#### Initial Setup
- ✅ Created Flutter project
- ✅ Setup Hive for local storage
- ✅ Configured asset structure
- ✅ Initial navigation setup

### 📝 Structure

#### Project Layout
```
lib/
  ├── models/          (Question, QuizResult models)
  ├── services/        (Business logic)
  ├── screens/         (UI screens)
  ├── widgets/         (Reusable components)
  └── main.dart        (Entry point)

assets/
  ├── data/            (YAML questions)
  └── images/          (PNG/JPG images)
```

#### Dependencies
- Flutter 3.24.5
- Hive 2.2.3
- YAML 3.1.2
- Image 4.0.17

---

## 📋 Version Strategy

**Format:** `[YYYY-MM-DD] - Feature/Theme`

**Categories:**
- 🎨 UI/Design changes
- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation
- 🔧 Configuration
- 🏗️ Architecture
- ⚡ Performance

---

## 🚀 Prochaines étapes

### À venir
- [ ] Add filtering by tags
- [ ] Implement bookmarking system
- [ ] Add practice mode
- [ ] Implement spaced repetition
- [ ] Add dark mode
- [ ] Multilingual support

### Considérations
- [ ] Performance optimization
- [ ] Offline sync
- [ ] Cloud backup
- [ ] Analytics
- [ ] A/B testing

---

**Dernière mise à jour:** 2025-11-10

**Maintenu par:** Development Team

**Pour contribuer:** Voir [ARCHITECTURE.md](ARCHITECTURE.md)
