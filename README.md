# 📱 Mobile Quiz App

**Application de quiz multi-catégories en Flutter - Quiz, Progression, Révision**

---

## 🎯 Qu'est-ce que c'est?

Une application mobile (Android/Linux) permettant de:
- ✅ **Faire des quiz** sur différentes catégories (Réseaux, Sécurité, etc.)
- ✅ **Tracker votre progression** avec des statistiques détaillées
- ✅ **Réviser vos erreurs** une question à la fois
- ✅ **Voir des images/schémas** intégrés dans les questions
- ✅ **Marquer vos favoris** pour révision ultérieure

**Parfait pour:** Étudiants, professionnels, formation continue

---

## 🚀 Démarrer rapidement

### ⚡ Super rapide (5 min)
👉 **[QUICK_START.md](QUICK_START.md)** - TL;DR pour chaque rôle

### 🎯 Onboarding guidé (20-45 min)
👉 **[ONBOARDING.md](ONBOARDING.md)** - Guide par étapes selon rôle

### 📖 Documentation complète par audience
- **Utilisateurs finaux** → [USER_GUIDE.md](USER_GUIDE.md)
- **Administrateurs** → [ADMIN_GUIDE.md](ADMIN_GUIDE.md)
- **Développeurs** → [ARCHITECTURE.md](ARCHITECTURE.md)

### 📚 Navigation centrale
👉 **[INDEX.md](INDEX.md)** - Index de tous les documents

---

## 🏗️ Architecture

```
Flutter (Dart)
    ↓
Hive (Base de données locale)
    ↓
YAML (Données catégories/questions)
    ↓
Assets (Images PNG/Web)
```

**Stack:** Flutter 3.24.5 | Dart 3.5.4 | Hive (NoSQL) | YAML

---

## 📦 Installation

### Build APK (Android)
```bash
cd mobile-quiz-app
flutter pub get
flutter build apk --release
# APK: build/app/outputs/apk/release/app-release.apk
```

### Run Linux (Développement)
```bash
flutter run -d linux
```

### Run Android (Développement)
```bash
flutter run -d android
```

---

## 📂 Structure du projet

```
mobile-quiz-app/
├── lib/                          # Code source Flutter
│   ├── models/                   # Modèles Hive (Question, QuizResult)
│   ├── screens/                  # Écrans Flutter (Quiz, Progression, etc.)
│   ├── services/                 # Logique métier (Storage, DataService, QuizEngine)
│   ├── widgets/                  # Composants réutilisables (ImageViewer, etc.)
│   ├── utils/                    # Utilitaires
│   └── main.dart                 # Point d'entrée
├── assets/
│   ├── data/                     # Catégories en YAML
│   │   ├── Reseaux/
│   │   ├── Securite/
│   │   └── ...
│   └── images/                   # Images PNG/JPG locales
│       ├── Reseaux/
│       └── ...
├── pubspec.yaml                  # Dépendances Flutter
└── README.md                     # Ce fichier
```

---

## 🎮 Utilisation rapide

### Écran d'accueil
```
[📝 QUIZ]          ← Commencer quiz
[📊 PROGRESSION]   ← Voir stats
[🔄 RÉVISION]      ← Retester erreurs
```

### Faire un quiz
1. Sélectionner catégorie(s)
2. Choisir nombre de questions (10, 30, 50, Toutes)
3. Répondre aux questions
4. Voir résultat

### Réviser
- Après quiz → "RÉVISER ERREURS"
- Reteste uniquement erreurs (ne compte pas pour score)

### Voir progression
- Écran "PROGRESSION"
- Graphiques + stats par catégorie
- Filtrer par difficulté

---

## 💾 Données

### Format questions (YAML)
```yaml
- id: net_q_001
  question: "Qu'est-ce qu'une adresse IP?"
  options:
    - Identifiant de paquet
    - Identifiant de périphérique
    - Identifiant de personne
  correct_answers:
    - Identifiant de périphérique
  explanation: "Une IP est l'adresse unique..."
  category: Reseaux
  difficulty: facile
  question_type: single
  points: 1
  images:              # Optionnel
    - id: img_001
      label: "Schéma"
      source: "assets/images/Reseaux/diagram.png"
```

### Types de données
- **Questions:** `assets/data/MaCategorie/questions.yaml`
- **Images locales:** `assets/images/MaCategorie/*.png`
- **Images web:** URLs HTTPS (auto-détectées)
- **Progression:** Hive (stockage local)

---

## 🛠️ Technologies

| Composant | Technologie |
|-----------|-------------|
| Framework | Flutter 3.24.5 |
| Langage | Dart 3.5.4 |
| Base de données | Hive (NoSQL) |
| Sérialisation | YAML |
| Images | Image package + InteractiveViewer |
| État | Hive + Provider |

---

## ✨ Fonctionnalités clés

✅ **Quiz multi-catégories**
- Mélange aléatoire des questions
- Choix simple ou multiple
- Score calculé immédiatement

✅ **Progression persistante**
- Stats sauvegardées automatiquement
- Historique par catégorie
- Statistiques par difficulté

✅ **Révision intelligente**
- Reteste uniquement les erreurs
- Hors du bilan (ne change pas score)
- Accès rapide après chaque quiz

✅ **Images intégrées**
- Schémas/diagrammes dans questions
- Support local (PNG) + web (HTTPS)
- Zoom/pinch + fullscreen viewer

✅ **Favoris**
- Marquer questions complexes
- Liste personnalisée
- Révision ciblée

✅ **Hors-ligne**
- Fonctionne 100% sans internet
- Images web optionnelles
- Aucun compte nécessaire

---

## 📊 Exemple utilisation

```
Jour 1: Première session
  • Sélectionner: Réseaux
  • Nombre: 10 questions
  • Score: 7/10 (70%)
  → Réviser 3 erreurs
  → Score révision: 2/3

Jour 2: Continuer
  • Sélectionner: Réseaux + Sécurité
  • Nombre: 30 questions
  • Score: 24/30 (80%)

Jour 3: Vérifier progression
  • Écran Progression
  • Voir: Réseaux 75%, Sécurité 80%
  • Graphiques + tendances
```

---

## 🐛 Troubleshooting

### L'app ne démarre pas
```bash
flutter clean
rm -rf build
flutter pub get
flutter run -d linux
```

### Les questions ne s'affichent pas
- Vérifier `pubspec.yaml` contient `- assets/data/MaCategorie/`
- Vérifier YAML valide (indentation 2 espaces)
- Recompiler APK

### Les images ne se chargent pas
- Images locales: Vérifier `pubspec.yaml` déclare dossier
- Images web: Vérifier URL HTTPS valide
- Recompiler

### Performance lente
- Fermer autres apps
- Vérifier RAM disponible
- Réduire taille images

---

## 📚 Documentation complète

| Document | Pour | Contenu |
|----------|------|---------|
| [INDEX.md](INDEX.md) | Tout le monde | Navigation documentation |
| [USER_GUIDE.md](USER_GUIDE.md) | Utilisateurs | Comment utiliser |
| [ADMIN_GUIDE.md](ADMIN_GUIDE.md) | Admins | Créer/modifier contenu |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Développeurs | Technique + code |
| [legacy-doc/](legacy-doc/) | Tout le monde | Archives anciennes docs |

---

## 🔄 Workflow administrateur

### Ajouter une catégorie
1. Créer: `assets/data/MaCategorie/`
2. Créer: `questions.yaml` + `flashcards.yaml`
3. Éditer: `pubspec.yaml`
4. Build: `flutter build apk --release`

### Modifier une question
1. Éditer: `assets/data/MaCategorie/questions.yaml`
2. Recompiler APK

### Ajouter des images
1. Copier PNG → `assets/images/MaCategorie/`
2. Éditer question YAML (ajouter section `images:`)
3. Recompiler APK

[👉 Guide complet: ADMIN_GUIDE.md](ADMIN_GUIDE.md)

---

## 🔄 Workflow développeur

### Développer une feature
1. Créer branche: `git checkout -b feature/nom`
2. Modifier code: `lib/`
3. Compiler: `flutter run -d linux`
4. Committer: `git commit -am "Description"`
5. Push: `git push`

### Déboguer
```bash
flutter run -d linux  # Dev mode
flutter run -d linux --verbose  # Logs complets
```

### Build
```bash
flutter build apk --release    # Production
flutter build apk --debug      # Dev
```

[👉 Guide technique: ARCHITECTURE.md](ARCHITECTURE.md)

---

## ⚙️ Configuration

### pubspec.yaml (principal)
```yaml
name: mobile_quiz_app
version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  yaml: ^3.1.2
  
assets:
  - assets/data/Reseaux/
  - assets/data/Securite/
  - assets/images/Reseaux/
  - assets/images/Securite/
```

---

## 📞 Support

**Questions?** Consulter:
- [INDEX.md](INDEX.md) - Navigation docs
- [USER_GUIDE.md](USER_GUIDE.md) - FAQ utilisateur
- [ADMIN_GUIDE.md](ADMIN_GUIDE.md) - FAQ admin
- [ARCHITECTURE.md](ARCHITECTURE.md) - FAQ dev

**Bugs?** Contacter équipe dev

---

## ✅ Status

- ✅ Quiz fonctionnel
- ✅ Images intégrées
- ✅ Progression tracée
- ✅ Révision une-shot
- ✅ Hors-ligne
- ✅ Documentation complète

---

**Dernière mise à jour:** 2025-11-10

**Prêt à démarrer?** 👉 Choisissez votre profil dans [INDEX.md](INDEX.md)

