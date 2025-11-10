# 👥 GUIDE UTILISATEUR - Comment utiliser l'application

**Pour les utilisateurs finaux de l'application**

---

## 📖 Table des matières

1. [Démarrer l'application](#démarrer-lapplication)
2. [Écran d'accueil](#écran-daccueil)
3. [Choisir une catégorie](#choisir-une-catégorie)
4. [Configurer le quiz](#configurer-le-quiz)
5. [Répondre aux questions](#répondre-aux-questions)
6. [Voir les résultats](#voir-les-résultats)
7. [Consulter la progression](#consulter-la-progression)
8. [Réviser les erreurs](#réviser-les-erreurs)
9. [Signets (Favoris)](#signets-favoris)
10. [Conseils & Astuces](#conseils--astuces)

---

## 🚀 Démarrer l'application

### Sur Android

1. **Trouver l'icône:** Chercher "Quiz App" sur l'écran d'accueil
2. **Lancer:** Appuyer sur l'icône
3. **Attendre:** L'app se charge (première fois: 5-10 secondes)
4. **Prêt:** Écran d'accueil s'affiche

### Sur Linux (développement)

```bash
flutter run -d linux
```

### Première ouverture

- ✅ L'app crée sa base de données
- ✅ Catégories se chargent automatiquement
- ✅ Aucun setup nécessaire
- ✅ Prêt à utiliser immédiatement

---

## 📱 Écran d'accueil

### Boutons principaux

| Bouton | Fonction |
|--------|----------|
| **📝 QUIZ** | Commencer un nouveau quiz |
| **📊 PROGRESSION** | Voir vos stats et avancement |
| **🔄 RÉVISION** | Retester vos erreurs |
| **⚙️ PARAMÈTRES** | Réglages (optionnel) |

### Infos affichées

- **Catégories disponibles:** Nombre total
- **Score global:** Pourcentage réussite
- **Dernière session:** Date/heure du dernier quiz

---

## ✏️ Choisir une catégorie

### Écran "Choisir des catégories"

1. **Lancer:** Bouton "📝 QUIZ"
2. **Voir la liste:** Toutes les catégories s'affichent

### Sélectionner une catégorie

**Méthode 1: Quiz unique**
- Cocher UNE catégorie
- Bouton "SUIVANT"

**Méthode 2: Quiz multi-catégories**
- Cocher PLUSIEURS catégories (ex: Réseaux + Sécurité)
- Bouton "SUIVANT"
- Questions mélangées de toutes les catégories sélectionnées

**Méthode 3: Tout sélectionner**
- Bouton "TOUT SÉLECTIONNER" (optionnel)
- Quiz sur l'ensemble des catégories

### Décocher une catégorie

- Appuyer de nouveau sur la catégorie cochée
- ✓ disparaît

---

## ⚙️ Configurer le quiz

### Écran "Nombre de questions"

Après sélection catégories, vous pouvez choisir le nombre de questions:

| Option | Signification |
|--------|---------------|
| **10** | 10 questions (rapide, ~5 min) |
| **30** | 30 questions (moyen, ~15 min) |
| **50** | 50 questions (long, ~30 min) |
| **Toutes** | Toutes les questions disponibles |

### Exemple

```
Catégorie sélectionnée: Réseaux (120 questions disponibles)
Choix: "50 questions"
→ Quiz avec 50 questions aléatoires de Réseaux
```

### Recommandations

- **Débutant:** Commencer avec **10** questions
- **Révision rapide:** Choisir **30** questions
- **Préparation examen:** Choisir **50** ou **Toutes**

---

## ❓ Répondre aux questions

### Format question unique (simple choice)

1. **Lire** la question et les options
2. **Cliquer** sur UNE SEULE option
3. **Voir** la barre de progression en haut
4. **Appuyer** "SUIVANT" ou "VALIDER"

```
Question: "Quel est le port HTTP?"
Options:  ☐ 20
          ☐ 80  ← Cliquer ici
          ☐ 443
          ☐ 3306
```

### Format questions multiples (multiple choice)

1. **Lire** la question (elle dit "Sélectionnez TOUTES les bonnes réponses")
2. **Cocher** PLUSIEURS options si nécessaire
3. **Valider** quand terminé

```
Question: "Quels sont les protocoles TCP?"
Options:  ☑ TCP  ← Coché
          ☐ UDP
          ☑ HTTPS  ← Coché
          ☐ DNS
```

### Boutons actions

| Bouton | Fonction |
|--------|----------|
| **🔔** | Signaler cette question (si ambiguë) |
| **💾** | Ajouter aux favoris (signet) |
| **📖** | Voir l'indice (si disponible) |
| **[Image]** | Voir schéma/diagramme (si disponible) |

### Voir une image/schéma

**Si des boutons images apparaissent:**

1. **Appuyer** sur le bouton (ex: "[Bus]", "[Étoile]")
2. **Voir** l'image en plein écran
3. **Actions:**
   - 🔍 **Zoom:** Pincer l'écran (écarter 2 doigts)
   - 🔄 **Dézoom:** Pincer vers vous
   - 👆 **Drag:** Glisser pour déplacer
4. **Fermer:** Bouton "✕" ou appuyer dehors

### Indice

**Si un indice est disponible:**

1. Bouton "📖 INDICE"
2. Lit le message d'aide
3. Aide à trouver la réponse sans la donner

---

## 🎯 Voir les résultats

### Après chaque question

**Vous verrez:**
- ✅ **Correct!** → Explication + points gagnés
- ❌ **Incorrect** → Explication + bonne réponse affichée

### Fin du quiz

**Écran résumé avec:**

| Info | Exemple |
|------|---------|
| **Total questions** | 30 |
| **Correct** | 24 |
| **Incorrect** | 6 |
| **Score** | 80% |
| **Temps moyen/question** | 35 secondes |
| **Points gagnés** | 48/50 pts |

### Boutons résumé

- **TERMINER**: Revenir à l'accueil
- **VOIR DÉTAILS**: Voir les réponses question par question
- **RÉVISER ERREURS**: Retester les 6 questions échouées

---

## 📊 Consulter la progression

### Écran Progression

Accès: **Accueil → 📊 PROGRESSION**

### Affichage

**Graphique en barres:**
- Axe X: Vos catégories
- Axe Y: Score (0-100%)
- Couleur: vert = bon, rouge = mauvais

**Tableau détails:**
- **Réseaux:** 85% (18/20 questions réussies)
- **Sécurité:** 72% (36/50 questions)
- **Bases de données:** 91% (10/11 questions)

### Filtrer par difficulté

**Boutons (optionnel):**
- "Toutes" : Tous les scores
- "Facile" : Score questions faciles uniquement
- "Moyen" : Score questions moyennes
- "Difficile" : Score questions difficiles

### Interprétation

```
Score 90-100% → Excellent! 🎉
Score 70-89%  → Bon, continuer révision
Score 50-69%  → À améliorer, refaire quiz
Score < 50%   → À travailler sérieusement
```

---

## 🔄 Réviser les erreurs

### Accès révision

1. **Écran Progression:** Bouton "🔄 RÉVISER"
2. OU **Écran Résultats:** Bouton "RÉVISER ERREURS"

### Qu'est-ce que la révision?

- ✅ Vous retestez **uniquement** les questions échouées
- ✅ Les mêmes questions, dans nouvel ordre
- ❌ Les résultats ne mettent **PAS à jour** votre score final
- ❌ Une révision est "jetable" = ne compte pas pour stats

### Flow révision

```
1. Sélectionner "Réviser"
2. App charge: 6 questions échouées
3. Retester (sans stress, c'est juste révision)
4. Voir résultats privés
5. Optionnel: "RÉVISER À NOUVEAU" ou revenir Accueil
```

### Quand réviser?

- **Après chaque quiz:** Immédiatement après les résultats
- **Avant examen:** Réviser 1-2 fois par jour les erreurs
- **Progression stagnante:** Réviser au lieu de tout refaire

---

## ⭐ Signets (Favoris)

### Marquer une question

**Pendant un quiz:**
1. Voir bouton "💾 AJOUTER AUX FAVORIS"
2. Appuyer
3. ✔️ Question sauvegardée

### Voir mes favoris

**Accès:** Accueil → ⭐ FAVORIS (optionnel)

### Utilité

- Collecter les questions complexes
- Réviser plus tard
- Créer liste personnalisée

### Actions sur favoris

- ✅ **Refaire:** Relancer quiz avec ces questions
- ✅ **Exporter:** Sauvegarder en fichier
- ❌ **Supprimer:** Retirer de favoris

---

## 💡 Conseils & Astuces

### Optimiser votre apprentissage

**✅ FAIRE:**
1. **Commencer petit:** 10 questions avant 50
2. **Lire explications:** Ne pas juste voir résultat
3. **Réviser rapidement:** Refaire erreurs le jour même
4. **Varier:** Mixer catégories différentes
5. **Augmenter progressivement:** 10 → 30 → 50 questions

**❌ NE PAS FAIRE:**
1. **Faire tout d'un coup:** 500 questions = fatigue
2. **Ignorer explications:** Lire = apprendre
3. **Revenir à 10q après une mauvaise session:** Normal d'échouer
4. **Spam réviser:** 1-2 révisions suffisent

### Gérer le temps

| Activité | Temps | Fréquence |
|----------|-------|-----------|
| Quiz 10 questions | 5-10 min | 2-3x/jour |
| Quiz 30 questions | 15-20 min | 1x/jour |
| Quiz 50 questions | 30-45 min | 1-2x/semaine |
| Réviser erreurs | 5-10 min | Après chaque quiz |

### Augmenter votre score

1. **Semaine 1:** Faire 10 questions/jour
2. **Semaine 2:** Ajouter révisions (5 min)
3. **Semaine 3:** Passer à 30 questions
4. **Semaine 4:** Cibler catégories faibles (< 70%)

### Avant un examen

**2 semaines avant:**
- Quiz 50 questions quotidiens
- Réviser erreurs immédiatement

**1 semaine avant:**
- Quiz 50 + 50 (matin/soir)
- Réviser chaque jour

**Veille examen:**
- Révision légère (30 minutes max)
- Pas de nouveau quiz

---

## ❓ FAQ (Questions Fréquentes)

### Q: Mes réponses sont sauvegardées?
**R:** Oui! Après chaque quiz, votre score est sauvegardé automatiquement. Vous pouvez voir votre progression n'importe quand.

### Q: Puis-je refaire le même quiz?
**R:** Oui! Questions sont mélangées à chaque fois. Vous pouvez faire les mêmes 50 questions 100 fois, elles seront dans ordre différent.

### Q: Les révisions comptent pour mon score?
**R:** Non! Les révisions sont "hors bilan". Elles vous aident à apprendre mais ne changent pas votre score final.

### Q: Comment réinitialiser mes scores?
**R:** Contactez l'administrateur. Les scores sont stockés localement sur votre téléphone/ordinateur.

### Q: Puis-je télécharger les questions?
**R:** Non, mais vous pouvez exporter vos favoris en fichier (optionnel).

### Q: L'app fonctionne hors ligne?
**R:** Oui, complètement! Aucun internet nécessaire (sauf pour images web).

### Q: Les images se chargent lentement?
**R:** Si image web (https://...), vérifiez votre connexion internet. Images locales (PNG) sont toujours rapides.

### Q: Je vois une question avec erreur/ambiguïté?
**R:** Bouton "🔔 SIGNALER" → Notifie l'administrateur.

### Q: Combien de catégories existent?
**R:** Variable! Demandez à votre administrateur. Écran sélection montre le nombre exact.

---

## 🆘 Troubleshooting

### L'app ne démarre pas

**Solution:**
```bash
# Supprimer cache local
rm -rf ~/.local/share/quiz_app
# Relancer app
flutter run -d linux
```

### Les questions ne s'affichent pas

**Vérifier:**
- [ ] Catégorie sélectionnée correctement
- [ ] Connexion internet (si images web)
- [ ] Quitter/relancer app

### Les résultats ne sauvegardent pas

**Solution:**
- Fermer et relancer l'app
- Vérifier espace disque disponible
- Contacter admin si problème persiste

### Performance lente

**Optimiser:**
- Fermer autres apps
- Vérifier RAM disponible
- Réduire taille images web (admin)

---

## 📞 Support & Contact

**Problèmes?** Contacter: votre administrateur

**Feedback?** Proposer améliorations: [canal support]

**Ressources:** Voir [README.md](README.md)

---

**Dernière mise à jour:** 2025-11-10
**Pour:** Utilisateurs finaux
**Niveau:** Débutant à Avancé
