# ⚡ QUICK START - 5 minutes

**TL;DR de chaque rôle**

---

## 👥 Utilisateur Final (5 min)

```bash
1. Installer APK
   adb install app-release.apk

2. Lancer
   → Icône Quiz App

3. Faire un quiz
   [QUIZ] → Sélectionner catégorie
   → Choisir 10 questions
   → Répondre 10 questions
   → Voir résultat

4. Réviser erreurs
   → Écran résultat → "RÉVISER ERREURS"
   → Retester
```

👉 [Guide complet](USER_GUIDE.md)

---

## 👨‍💼 Administrateur (5 min)

```bash
1. Créer catégorie
   mkdir assets/data/MaCategorie
   
2. Créer questions.yaml
   assets/data/MaCategorie/questions.yaml
   
   - id: cat_q_001
     question: "Votre question?"
     options: ["A", "B", "C"]
     correct_answers: ["A"]
     explanation: "Explique"
     category: MaCategorie
     difficulty: facile
     question_type: single
     points: 1

3. Éditer pubspec.yaml
   assets:
     - assets/data/MaCategorie/
     
4. Build
   flutter build apk --release
   
5. Tester
   → Lancer app → Voir nouvelle catégorie ✅
```

👉 [Guide complet](ADMIN_GUIDE.md)

---

## 👨‍💻 Développeur (5 min)

```bash
1. Setup
   git clone [repo]
   cd mobile-quiz-app
   flutter pub get
   flutter pub run build_runner build
   
2. Lancer dev
   flutter run -d linux
   
3. Modifier code
   lib/screens/quiz_screen.dart (ou autre)
   
4. Hot-reload
   [Press 'r' dans terminal]
   
5. Build production
   flutter build apk --release
```

**Structure code:**
```
lib/
  ├── models/question.dart         ← Modèle question
  ├── services/storage_service.dart ← Sauvegarde résultats
  ├── services/quiz_engine.dart    ← Logique quiz
  └── screens/quiz_screen.dart     ← Interface quiz
```

👉 [Guide complet](ARCHITECTURE.md)

---

## 🆘 Troubleshooting rapide

| Problème | Solution |
|----------|----------|
| App ne démarre pas | `flutter clean && flutter run -d linux` |
| Catégorie n'apparaît pas | Vérifier `pubspec.yaml` + `flutter pub get` |
| Questions ne s'affichent pas | Vérifier YAML (indentation 2 espaces) |
| Images ne s'affichent pas | Vérifier chemin + recompiler APK |

---

## 📚 Navigation

- **UTILISATEURS** → [USER_GUIDE.md](USER_GUIDE.md)
- **ADMINS** → [ADMIN_GUIDE.md](ADMIN_GUIDE.md)
- **DEVS** → [ARCHITECTURE.md](ARCHITECTURE.md)
- **INDEX** → [INDEX.md](INDEX.md)

---

**Prêt à démarrer?** 🚀
