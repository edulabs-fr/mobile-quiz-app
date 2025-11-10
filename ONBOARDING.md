# 🚀 ONBOARDING - Démarrer rapidement

**Bienvenue! Suivez ce guide selon votre rôle.**

---

## 👤 Quel est votre rôle?

### 👥 Je suis un UTILISATEUR FINAL

**Vous voulez:** Utiliser l'app pour faire des quiz et progresser

**Temps:** ⏱️ ~20 minutes

**Étapes:**

1. **Installer l'app**
   ```bash
   # Si vous recevez un fichier APK
   adb install app-release.apk
   
   # OU simplement installer depuis Play Store (si disponible)
   ```

2. **Lancer et explorer**
   - Ouvrir l'app
   - Cliquer "📝 QUIZ"
   - Sélectionner une catégorie
   - Choisir 10 questions
   - Répondre quelques questions

3. **Consulter documentation**
   - [USER_GUIDE.md](USER_GUIDE.md) - Guide complet
   - [FAQ section](USER_GUIDE.md#faq-questions-fréquentes) - Questions courantes

4. **Vous êtes prêt!** ✅
   - Faire des quizzes
   - Voir progression
   - Réviser erreurs

👉 **[Aller à USER_GUIDE.md](USER_GUIDE.md)**

---

### 👨‍💼 Je suis un ADMINISTRATEUR

**Vous voulez:** Créer/modifier les catégories et questions

**Temps:** ⏱️ ~30 minutes

**Étapes:**

1. **Comprendre la structure**
   - Catégories = dossiers dans `assets/data/`
   - Questions = fichiers YAML
   - Images = dossiers dans `assets/images/`

2. **Créer votre première catégorie**
   - Créer: `assets/data/MaTestCategorie/`
   - Créer: fichier `questions.yaml` (3-5 questions)
   - Éditer: `pubspec.yaml` (ajouter asset)
   - Build: `flutter build apk --release`
   - Tester: Ouvrir app, voir nouvelle catégorie ✅

3. **Consulter documentation**
   - [ADMIN_GUIDE.md](ADMIN_GUIDE.md) - Guide complet
   - [Créer une catégorie](ADMIN_GUIDE.md#étape-1-créer-la-structure-de-dossiers) - Instructions détaillées
   - [Format YAML](ADMIN_GUIDE.md#format-yaml-obligatoire) - Tous les champs
   - [Troubleshooting](ADMIN_GUIDE.md#validation--troubleshooting) - Solutions

4. **Vous êtes prêt!** ✅
   - Créer catégories
   - Modifier questions
   - Ajouter images

👉 **[Aller à ADMIN_GUIDE.md](ADMIN_GUIDE.md)**

---

### 👨‍💻 Je suis un DÉVELOPPEUR

**Vous voulez:** Maintenir/développer l'application

**Temps:** ⏱️ ~45 minutes

**Étapes:**

1. **Setup environnement**
   ```bash
   # Cloner repo
   git clone [repo-url]
   cd mobile-quiz-app
   
   # Installer dépendances
   flutter pub get
   
   # Générer adapters Hive
   flutter pub run build_runner build
   
   # Lancer en dev
   flutter run -d linux
   ```

2. **Comprendre l'architecture**
   - Lire: [ARCHITECTURE.md](ARCHITECTURE.md) - Overviews
   - Sections clés:
     - [Stack Technologique](ARCHITECTURE.md#stack-technologique) - Tech utilisée
     - [Modules Principaux](ARCHITECTURE.md#modules-principaux) - Code structure
     - [Flows Principaux](ARCHITECTURE.md#flows-principaux) - Logique

3. **Explorer le code**
   ```bash
   lib/
   ├── main.dart                    # Entry point
   ├── models/
   │   ├── question.dart           # Question model
   │   └── quiz_result.dart        # Results model
   ├── services/
   │   ├── storage_service.dart    # Hive persistence
   │   ├── data_service.dart       # Load YAML
   │   └── quiz_engine.dart        # Quiz logic
   └── screens/
       ├── quiz_screen.dart        # Main quiz UI
       └── progress_screen.dart    # Stats
   ```

4. **Compiler & tester**
   ```bash
   # Dev mode
   flutter run -d linux
   
   # Hot reload (après modif)
   # Appuyer 'r' dans terminal
   
   # Production build
   flutter build apk --release
   ```

5. **Vous êtes prêt!** ✅
   - Développer features
   - Fixer bugs
   - Contribuer

👉 **[Aller à ARCHITECTURE.md](ARCHITECTURE.md)**

---

## 🤔 Je ne sais pas quel rôle j'ai

**Consultez ce tableau:**

| Question | Réponse | Allez à |
|----------|---------|---------|
| **Je reçois une app APK** | Oui (utilisateur final) | [USER_GUIDE.md](USER_GUIDE.md) |
| **Je dois créer les questions** | Oui (administrateur) | [ADMIN_GUIDE.md](ADMIN_GUIDE.md) |
| **Je dois modifier le code** | Oui (développeur) | [ARCHITECTURE.md](ARCHITECTURE.md) |
| **Je ne sais toujours pas** | ❓ | [INDEX.md](INDEX.md) |

---

## 📚 Ressources rapides

### Documentation
- 📘 [README.md](README.md) - Projet overview
- 📗 [INDEX.md](INDEX.md) - Navigation docs
- 📙 [ARCHITECTURE.md](ARCHITECTURE.md) - Technique
- 📕 [ADMIN_GUIDE.md](ADMIN_GUIDE.md) - Administrateurs
- 📓 [USER_GUIDE.md](USER_GUIDE.md) - Utilisateurs

### Dossiers importants
```
assets/
  ├── data/              ← Catégories (YAML)
  └── images/            ← Images locales (PNG)

lib/
  ├── models/            ← Models Hive
  ├── services/          ← Logique métier
  ├── screens/           ← Écrans Flutter
  └── widgets/           ← Composants
```

### Commandes utiles
```bash
# Développement
flutter run -d linux                    # Lancer dev
flutter run -d linux --verbose         # Avec logs

# Build production
flutter build apk --release             # Android APK
flutter build apk --debug               # Debug APK

# Maintenance
flutter clean                           # Nettoyer cache
flutter pub get                         # Installer dépendances
flutter pub run build_runner build     # Générer .g.dart (Hive)
```

---

## ✅ Checklist démarrage

### UTILISATEURS
- [ ] App installée
- [ ] App lancée
- [ ] Premier quiz complété
- [ ] Progression consultée
- [ ] [USER_GUIDE.md](USER_GUIDE.md) lu

### ADMINISTRATEURS
- [ ] Environnement setup
- [ ] Structure dossiers comprise
- [ ] Première catégorie créée
- [ ] APK compilée avec nouvelle catégorie
- [ ] [ADMIN_GUIDE.md](ADMIN_GUIDE.md) lu
- [ ] [Format YAML](ADMIN_GUIDE.md#format-yaml-obligatoire) compris

### DÉVELOPPEURS
- [ ] Repo cloné
- [ ] Flutter installé
- [ ] App lancée en dev (`flutter run -d linux`)
- [ ] Code source exploré (lib/)
- [ ] [ARCHITECTURE.md](ARCHITECTURE.md) lu
- [ ] Premier hot-reload testé

---

## 🎯 Objectif suivant

**Une fois l'onboarding terminé:**

### UTILISATEURS
→ Faire 10 quiz / jour

### ADMINISTRATEURS
→ Créer 5 catégories test

### DÉVELOPPEURS
→ Implémenter 1 feature ou fix 1 bug

---

## ❓ Questions fréquentes

**Q: Où trouver plus d'aide?**  
R: Consulter [INDEX.md](INDEX.md) pour navigation par profil.

**Q: Je veux en savoir plus sur X?**  
R: Utiliser Ctrl+F dans le document pertinent, ou chercher dans [INDEX.md](INDEX.md).

**Q: Qui contacter si problème?**  
R: Contacter votre administrateur/équipe dev.

**Q: Comment contribuer?**  
R: (Voir [ARCHITECTURE.md](ARCHITECTURE.md) pour développeurs)

---

## 🎉 Bienvenue dans l'équipe!

Vous êtes maintenant prêt à démarrer.

**Prochaines étapes:**

1. ✅ Choisir votre guide (section ci-dessus)
2. ✅ Lire le guide correspondant (20-45 min)
3. ✅ Faire votre première action
4. ✅ Avoir du plaisir! 🚀

---

**Besoin d'aide?** Consulter [INDEX.md](INDEX.md)

**Bonne chance!** 🎊

