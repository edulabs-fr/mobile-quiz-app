# 📚 Comment ajouter une nouvelle catégorie dans l'application Quiz

Ce guide explique comment ajouter une nouvelle catégorie de questions et flashcards dans l'application.

## ⚡ Résumé rapide (5 étapes)

1. **Créer le dossier** : `assets/data/MaCategorie/`
2. **Créer 2 fichiers YAML** : `questions.yaml` et `flashcards.yaml`
3. **Déclarer dans `pubspec.yaml`** : ajouter `- assets/data/MaCategorie/`
4. **Déclarer dans `data_service.dart`** : ajouter `'MaCategorie'` à la liste `allCategories`
5. **Relancer l'app** : `R` dans le terminal ou `flutter run`

**ATTENTION** : Les étapes 3 et 4 sont OBLIGATOIRES ! Sans elles, la catégorie n'apparaîtra pas.

## 🎯 Vue d'ensemble

Chaque catégorie est un **dossier** dans `assets/data/` contenant 2 fichiers YAML :
- `questions.yaml` - Les questions QCM
- `flashcards.yaml` - Les cartes mémoire

L'application détecte **automatiquement** toutes les catégories déclarées dans `pubspec.yaml`.

---

## ✅ Procédure complète

### Étape 1️⃣ : Créer le dossier de la catégorie

Créez un nouveau dossier dans `assets/data/` :

```bash
quiz_app/assets/data/MaCategorie/
```

**Règles de nommage** :
- Utilisez des underscores `_` pour les espaces : `Cloud_Computing`
- Ou gardez les espaces/accents : `Réseaux`, `Sécurité`, `Base de données`
- Le nom du dossier = le nom affiché dans l'app

**Exemples** :
```
assets/data/DevOps/
assets/data/Réseaux/
assets/data/Cloud_Computing/
assets/data/Base_de_données/
assets/data/Sécurité/
```

---

### Étape 2️⃣ : Créer le fichier `questions.yaml`

Créez `assets/data/MaCategorie/questions.yaml` avec ce format :

```yaml
# ============================================
# Questions MaCategorie
# ============================================

- id: "categorie_q1"
  question: "Votre question ici ?"
  options:
    - "Réponse A"
    - "Réponse B"
    - "Réponse C"
    - "Réponse D"
  correct_answers:
    - "Réponse A"
  explanation: "Explication détaillée de pourquoi cette réponse est correcte"
  hint: "Un indice pour aider (optionnel)"
  difficulty: "facile"  # facile, moyen, ou difficile
  tags:
    - "tag1"
    - "tag2"
  reference: "https://lien-vers-doc.com (optionnel)"

- id: "categorie_q2"
  question: "Question à choix multiples (plusieurs bonnes réponses) ?"
  options:
    - "Option 1"
    - "Option 2"
    - "Option 3"
    - "Option 4"
  correct_answers:
    - "Option 1"
    - "Option 3"  # Plusieurs bonnes réponses = QCM multiple
  explanation: "Explication..."
  difficulty: "moyen"
  tags:
    - "qcm"
```

**Champs obligatoires** :
- ✅ `id` - Identifiant unique (ex: `reseaux_q1`, `devops_q1`)
- ✅ `question` - Texte de la question
- ✅ `options` - Liste de 2 à 10 réponses possibles
- ✅ `correct_answers` - Liste des bonnes réponses (1 = simple, 2+ = multiple)
- ✅ `explanation` - Explication de la réponse
- ✅ `difficulty` - `facile`, `moyen` ou `difficile`

**Champs optionnels** :
- `hint` - Indice pour aider
- `tags` - Mots-clés pour recherche
- `reference` - Lien vers documentation
- `question_type` - Auto-détecté selon `correct_answers`
- `points` - Nombre de points (défaut: 1)

---

### Étape 3️⃣ : Créer le fichier `flashcards.yaml`

Créez `assets/data/MaCategorie/flashcards.yaml` avec ce format :

```yaml
# ============================================
# Flashcards MaCategorie
# ============================================

- id: "categorie_f1"
  front: "Question ou concept à apprendre"
  back: "Réponse ou explication détaillée"
  difficulty: "facile"
  tags:
    - "tag1"
    - "tag2"

- id: "categorie_f2"
  front: "Qu'est-ce que X ?"
  back: "X est...\n\nVous pouvez utiliser plusieurs lignes\net même des listes :\n- Point 1\n- Point 2\n- Point 3"
  difficulty: "moyen"
  tags:
    - "definition"
```

**Champs obligatoires** :
- ✅ `id` - Identifiant unique
- ✅ `front` - Face avant (question/terme)
- ✅ `back` - Face arrière (réponse/définition)
- ✅ `difficulty` - `facile`, `moyen` ou `difficile`

**Champs optionnels** :
- `tags` - Mots-clés pour recherche

---

### Étape 4️⃣ : Déclarer dans `pubspec.yaml` ⚠️ **IMPORTANT**

**C'est l'étape OBLIGATOIRE !** Sans elle, Flutter ne peut pas charger les fichiers.

Ouvrez `quiz_app/pubspec.yaml` et ajoutez votre catégorie dans la section `assets` :

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/data/user_management/
    - assets/data/filesystem/
    - assets/data/service/
    - assets/data/Réseaux/           # ← AJOUTER ICI
    - assets/data/MaCategorie/       # ← AJOUTER ICI
```

**Important** :
- Le slash `/` à la fin est obligatoire
- Respectez l'indentation (2 espaces)
- Le nom DOIT correspondre exactement au nom du dossier

### Étape 5️⃣ : Déclarer dans `lib/services/data_service.dart` ⚠️ **CRUCIAL**

**Cette étape est essentielle !** L'application détecte les catégories via une liste codée en dur.

Ouvrez `lib/services/data_service.dart` et trouvez la méthode `getAvailableCategories()` (ligne ~89) :

```dart
static Future<List<String>> getAvailableCategories() async {
  // Pour le MVP, nous retournons uniquement les catégories qui ont des fichiers
  final List<String> allCategories = [
    'user_management',
    'filesystem',
    'service',
    'Réseaux',           # ← AJOUTER ICI
    'MaCategorie',       # ← AJOUTER ICI
  ];
  
  // Filtrer pour ne garder que celles qui ont des questions
  final List<String> availableCategories = [];
  for (final category in allCategories) {
    try {
      final questions = await loadQuestions(category);
      if (questions.isNotEmpty) {
        availableCategories.add(category);
      }
    } catch (e) {
      // Ignorer les catégories qui n'existent pas
    }
  }
  
  return availableCategories;
}
```

**⚠️ ATTENTION** : Le nom dans cette liste DOIT correspondre exactement au nom du dossier (y compris les majuscules/minuscules et les accents) !

### Étape 6️⃣ : Relancer l'application

Les assets ne sont pas détectés par le hot reload. Vous devez :

**Option A - Hot Restart** (plus rapide) :
```bash
# Si l'app tourne déjà, appuyez sur R dans le terminal
R
```

**Option B - Relance complète** :
```bash
cd quiz_app
flutter run
```

---

## 🎯 Exemple complet : Catégorie "DevOps"

### Structure des fichiers
```
quiz_app/
└── assets/
    └── data/
        └── DevOps/
            ├── questions.yaml
            └── flashcards.yaml
```

### `questions.yaml`
```yaml
- id: "devops_q1"
  question: "Qu'est-ce que l'intégration continue (CI) ?"
  options:
    - "Un processus d'automatisation des tests et du déploiement"
    - "Une méthode de gestion de projet agile"
    - "Un outil de versioning de code"
    - "Un langage de programmation"
  correct_answers:
    - "Un processus d'automatisation des tests et du déploiement"
  explanation: "L'intégration continue (CI) est une pratique de développement logiciel où les développeurs intègrent régulièrement leur code dans un dépôt partagé."
  hint: "Pensez à l'automatisation"
  difficulty: "facile"
  tags:
    - "CI/CD"
    - "Automatisation"

- id: "devops_q2"
  question: "Quels sont les principaux outils de CI/CD ?"
  options:
    - "Jenkins"
    - "GitLab CI"
    - "Microsoft Word"
    - "GitHub Actions"
  correct_answers:
    - "Jenkins"
    - "GitLab CI"
    - "GitHub Actions"
  explanation: "Jenkins, GitLab CI et GitHub Actions sont des outils populaires pour l'intégration et le déploiement continus."
  difficulty: "moyen"
```

### `flashcards.yaml`
```yaml
- id: "devops_f1"
  front: "Que signifie CI/CD ?"
  back: "CI/CD signifie Continuous Integration / Continuous Deployment (Intégration Continue / Déploiement Continu)."
  difficulty: "facile"
  tags:
    - "CI/CD"
    - "Terminologie"

- id: "devops_f2"
  front: "Qu'est-ce qu'un pipeline CI/CD ?"
  back: "Un pipeline CI/CD est une série d'étapes automatisées :\n\n1. Git Push\n2. Build\n3. Tests\n4. Deploy to Staging\n5. Deploy to Production"
  difficulty: "moyen"
```

### `pubspec.yaml`
```yaml
assets:
  - assets/data/user_management/
  - assets/data/filesystem/
  - assets/data/service/
  - assets/data/DevOps/              # ← Ligne ajoutée
```

---

## �️ Étape 6️⃣ (Optionnel) : Ajouter des images à la catégorie

Vous pouvez ajouter des **images locales** et/ou des **images distantes (web)** à vos questions !

### Structure des images

Créez un dossier pour les images locales :
```
quiz_app/
├── assets/
│   ├── data/
│   │   └── MaCategorie/
│   │       ├── questions.yaml
│   │       └── flashcards.yaml
│   └── images/
│       └── MaCategorie/              # ← Créer ce dossier
│           ├── image1.png
│           ├── image2.png
│           └── ...
└── pubspec.yaml
```

**Format d'image supporté** : PNG, JPG, GIF
**Taille recommandée** : 800x600px max, <2MB par image

### Déclarer les images dans `pubspec.yaml`

Ajoutez le dossier d'images à la section `assets` :

```yaml
flutter:
  assets:
    - assets/data/user_management/
    - assets/data/filesystem/
    - assets/data/service/
    - assets/data/MaCategorie/
    # Images pour les questions
    - assets/images/user_management/
    - assets/images/filesystem/
    - assets/images/service/
    - assets/images/MaCategorie/       # ← AJOUTER ICI
```

### Créer des questions avec images

Modifiez vos questions YAML pour ajouter des images :

#### Option 1 : Images locales uniquement

```yaml
- id: "macategorie_q1"
  question: "Observez le schéma ci-dessous. Quel est le bon ordre ?"
  images:
    - id: "img_mc_q1_1"
      label: "Architecture A"
      source: "assets/images/MaCategorie/architecture_a.png"
      description: "Architecture avec configuration A"
    
    - id: "img_mc_q1_2"
      label: "Architecture B"
      source: "assets/images/MaCategorie/architecture_b.png"
      description: "Architecture avec configuration B"
  
  options:
    - "Architecture A"
    - "Architecture B"
    - "Les deux"
    - "Aucune"
  
  correct_answers:
    - "Architecture A"
  
  explanation: "L'architecture A est correcte car..."
  difficulty: "moyen"
  tags:
    - "architecture"
    - "images"
```

#### Option 2 : Images distantes (URLs web)

```yaml
- id: "macategorie_q2"
  question: "Identifiez le composant sur l'image officielle"
  images:
    - id: "img_mc_q2_1"
      label: "Schéma officiel"
      source: "https://example.com/official-diagram.png"
      description: "Diagramme officiel du composant"
  
  options:
    - "Composant A"
    - "Composant B"
  
  correct_answers:
    - "Composant A"
  
  explanation: "..."
  difficulty: "facile"
```

#### Option 3 : Mélanger images locales ET web

```yaml
- id: "macategorie_q3"
  question: "Comparez les deux approches"
  images:
    # Image locale
    - id: "img_mc_q3_1"
      label: "Notre diagramme"
      source: "assets/images/MaCategorie/our_diagram.png"
      description: "Diagramme personnalisé"
    
    # Image depuis le web
    - id: "img_mc_q3_2"
      label: "Référence officielle"
      source: "https://en.wikipedia.org/wiki/...png"
      description: "Diagramme de référence"
  
  options:
    - "Approche 1"
    - "Approche 2"
  
  correct_answers:
    - "Approche 1"
  
  explanation: "..."
  difficulty: "moyen"
  tags:
    - "comparaison"
    - "images"
```

### Format des images

**Champs obligatoires** :
- ✅ `id` - Identifiant unique (ex: `img_mc_q1_1`)
- ✅ `label` - Titre de l'image (ex: "Architecture Bus")
- ✅ `source` - URL web OU chemin asset
- ✅ `description` - Description pour l'accessibilité

**Source locale** :
```yaml
source: "assets/images/MaCategorie/nom_fichier.png"
```

**Source distante** :
```yaml
source: "https://example.com/image.png"
source: "https://www.museeinformatique.fr/wp-content/uploads/2022/07/réseau.jpg"
```

### Fonctionnalités des images

Les images supportent automatiquement :
- 🔍 **Pinch-to-zoom** : Geste pour zoomer/dézoomer
- 🖱️ **Double-tap** : Double-clic pour zoom 3x
- 🖼️ **Galerie** : Miniatures cliquables en bas de la question
- 📱 **Full-screen** : Click pour voir en grand dans une dialog

---

## 🎯 Exemple complet : Catégorie "Réseaux" avec images

### `questions.yaml`

```yaml
- id: "reseaux_q1"
  question: "Observez les trois architectures réseau ci-dessous. Quelle est l'architecture en ÉTOILE ?"
  images:
    - id: "img_res_q1_1"
      label: "Topologie Bus"
      source: "assets/images/Réseaux/network_bus.png"
      description: "Tous les appareils connectés sur un même câble"
    
    - id: "img_res_q1_2"
      label: "Topologie Étoile"
      source: "assets/images/Réseaux/network_star.png"
      description: "Tous les appareils connectés à un switch central"
    
    - id: "img_res_q1_3"
      label: "Topologie Maille"
      source: "https://upload.wikimedia.org/wikipedia/commons/mesh-network.png"
      description: "Chaque appareil connecté à plusieurs autres"
  
  options:
    - "Topologie Bus"
    - "Topologie Étoile"
    - "Topologie Maille"
  
  correct_answers:
    - "Topologie Étoile"
  
  explanation: "L'architecture en étoile est la plus courante. Elle utilise un équipement central (switch) auquel tous les appareils se connectent. Cela permet une gestion centralisée et une meilleure scalabilité."
  
  hint: "Cherchez la configuration avec un point central"
  difficulty: "facile"
  tags:
    - "topologie réseau"
    - "architecture"
    - "images"
  points: 2

- id: "reseaux_q2"
  question: "Identifiez le modèle OSI sur le diagramme suivant"
  images:
    - id: "img_res_q2_1"
      label: "Modèle OSI"
      source: "assets/images/Réseaux/osi_model.png"
      description: "Les 7 couches du modèle OSI"
  
  options:
    - "3 couches"
    - "5 couches"
    - "7 couches"
    - "10 couches"
  
  correct_answers:
    - "7 couches"
  
  explanation: "Le modèle OSI (Open Systems Interconnection) est composé de 7 couches : Physique, Liaison, Réseau, Transport, Session, Présentation et Application."
  
  difficulty: "moyen"
  tags:
    - "modèle OSI"
    - "couches réseau"
```

### Vérifier les images dans l'app

Après avoir relancé l'app :

1. **Créer un quiz** de la catégorie
2. **Observer les questions** : les images apparaissent sous la question
3. **Cliquer les miniatures** : voir les images en grand
4. **Essayer le zoom** :
   - Pinch-to-zoom avec doigts
   - Double-tap pour zoom 3x

---

## 📋 Checklist images

- [ ] Créer dossier `assets/images/MaCategorie/`
- [ ] Placer images PNG/JPG (800x600px max)
- [ ] Ajouter `assets/images/MaCategorie/` dans `pubspec.yaml`
- [ ] Ajouter champ `images:` dans questions YAML
- [ ] Vérifier que `source:` pointe vers le bon chemin/URL
- [ ] Vérifier tous les champs obligatoires (`id`, `label`, `source`, `description`)
- [ ] Hot restart (R) ou `flutter run`
- [ ] Tester : créer quiz et vérifier images
- [ ] Tester zoom : pinch et double-tap

---

## 🔄 Étape 7️⃣ : Relancer l'application

Les images locales ne sont pas détectées par le hot reload. Vous devez relancer complètement :

```bash
# Hot restart
R

# Ou relance complète
flutter clean && flutter run
```

---

## 🖼️ Vérification

Après avoir suivi ces étapes, votre catégorie devrait apparaître :

✅ **Dans l'écran Quiz** :
1. Ouvrez l'app
2. Allez dans l'onglet "Quiz"
3. Votre catégorie apparaît avec le nombre de questions
4. **Si questions avec images** : Les images s'affichent sous chaque question

✅ **Dans l'écran Flashcards** :
1. Allez dans l'onglet "Flashcards"
2. Votre catégorie apparaît avec le nombre de cartes

✅ **Images (si ajoutées)** :
1. Créer un quiz avec une question qui a des images
2. Les miniatures d'images apparaissent en galerie
3. Cliquer une miniature → zoom full-screen dans dialog
4. Essayer pinch-to-zoom et double-tap

---

## ❌ Problèmes courants

### La catégorie n'apparaît pas

**Cause 1** : Pas dans `pubspec.yaml`
```yaml
# ❌ MAUVAIS - pas déclaré
assets:
  - assets/data/user_management/

# ✅ BON
assets:
  - assets/data/user_management/
  - assets/data/MaCategorie/
```

**Cause 2** : Pas dans `lib/services/data_service.dart` ⚠️ **CRUCIAL**
```dart
// ❌ MAUVAIS - liste incomplète
final List<String> allCategories = [
  'user_management',
  'filesystem',
  'service',
];

// ✅ BON
final List<String> allCategories = [
  'user_management',
  'filesystem',
  'service',
  'MaCategorie',
];
```

**⚠️ IMPORTANT** : Cette étape est CRUCIALE ! Sans elle, même si les fichiers existent et sont dans pubspec.yaml, la catégorie ne s'affichera pas.

**Cause 3** : Fichiers YAML manquants ou mal nommés
```
✅ Correct :
assets/data/MaCategorie/questions.yaml
assets/data/MaCategorie/flashcards.yaml

❌ Incorrect :
assets/data/MaCategorie/question.yaml    # sans 's'
assets/data/MaCategorie/flashcard.yaml   # sans 's'
```

**Cause 4** : Erreur YAML dans les fichiers
- Vérifiez l'indentation (2 espaces, pas de tabs)
- Vérifiez les tirets `-` au début de chaque élément de liste
- Mettez les textes avec `:` ou `?` entre guillemets
- **Vérifiez que les noms de catégorie correspondent exactement** (majuscules/minuscules/accents)

**Cause 5** : Pas de hot restart
- Appuyez sur `R` dans le terminal Flutter (et pas `r`)
- Ou relancez complètement l'app : `flutter run`

### Images : fichiers non trouvés

**Cause 6** : Dossier `assets/images/` pas créé ou mal déclaré
```
❌ MAUVAIS - Pas dans pubspec.yaml
assets:
  - assets/data/MaCategorie/

✅ BON - Ajoutez aussi les images
assets:
  - assets/data/MaCategorie/
  - assets/images/MaCategorie/
```

**Cause 7** : Chemin image incorrect dans YAML
```yaml
# ❌ MAUVAIS - chemin mal écrit
source: "assets/images/macategorie/image.png"     # minuscule != majuscule
source: "assets/images/MaCategorie/imagee.png"    # typo dans nom

# ✅ BON - chemin correct
source: "assets/images/MaCategorie/image.png"
source: "assets/images/Réseaux/network_star.png"
```

**Cause 8** : Images distantes (URLs) ne chargent pas
```yaml
# ❌ MAUVAIS - URL inaccessible
source: "https://broken-url.com/image.png"

# ✅ BON - URL valide et accessible
source: "https://en.wikipedia.org/wiki/image.png"
source: "https://www.museeinformatique.fr/...image.jpg"
```

**Cause 9** : Image locale introuvable (fichier YAML)
```
✅ Vérifier :
- Le fichier PNG/JPG existe dans assets/images/MaCategorie/
- L'extension est correcte (.png, .jpg, pas .PNG ou .JPG)
- Le nom est exactement le même dans le YAML et le disque
- Pas de caractères spéciaux ou espaces dans le nom de fichier
```

---

## 📝 Bonnes pratiques

### Nommage des IDs
```yaml
# ✅ BON - préfixe avec nom catégorie
- id: "devops_q1"
- id: "reseaux_q1"
- id: "securite_f1"

# ❌ MAUVAIS - risque de collision
- id: "q1"
- id: "question1"
```

### Difficultés équilibrées
```yaml
# Essayez d'avoir un mix équilibré :
# - 40% facile
# - 40% moyen
# - 20% difficile
```

### Explications complètes
```yaml
explanation: "L'explication doit être pédagogique et complète, pas juste répéter la bonne réponse. Expliquez le POURQUOI."
```

### Tags pertinents
```yaml
tags:
  - "CI/CD"           # Concept principal
  - "Jenkins"         # Outil spécifique
  - "Automatisation"  # Catégorie large
```

---

## 🎨 Formatage YAML

### Texte sur plusieurs lignes
```yaml
back: |
  Première ligne
  Deuxième ligne
  Troisième ligne
```

### Texte avec guillemets
```yaml
question: "Qu'est-ce que Docker ?"  # Avec ? ou : utilisez des guillemets
options:
  - "Option avec : dedans"
  - Option simple
```

### Listes imbriquées
```yaml
options:
  - "Option 1"
  - "Option 2"
  - "Option 3"
correct_answers:
  - "Option 1"
tags:
  - "tag1"
  - "tag2"
```

---

## 🚀 Checklist complète

### Questions et Flashcards
- [ ] Créer le dossier `assets/data/MaCategorie/`
- [ ] Créer `questions.yaml` avec au moins 1 question
- [ ] Créer `flashcards.yaml` avec au least 1 carte
- [ ] **Ajouter dans `pubspec.yaml`** section `assets`
- [ ] **Ajouter dans `lib/services/data_service.dart`** méthode `getAvailableCategories()`
- [ ] Vérifier l'indentation YAML (2 espaces)
- [ ] Vérifier que tous les champs obligatoires sont présents
- [ ] Vérifier les noms de catégorie (doivent correspondre exactement)

### Images (optionnel)
- [ ] ❌ Si pas d'images → passer au test
- [ ] ✅ Si images locales → Créer dossier `assets/images/MaCategorie/`
- [ ] ✅ Si images locales → Placer fichiers PNG/JPG (800x600px max)
- [ ] ✅ Si images locales → Ajouter `- assets/images/MaCategorie/` dans `pubspec.yaml`
- [ ] ✅ Ajouter champ `images:` dans questions YAML
- [ ] ✅ Vérifier `source:` pointe vers bon chemin/URL
- [ ] ✅ Vérifier tous les champs image : `id`, `label`, `source`, `description`

### Test et validation
- [ ] Hot restart (R) ou relancer l'app
- [ ] Vérifier dans Quiz que la catégorie apparaît
- [ ] Vérifier dans Flashcards que la catégorie apparaît
- [ ] Tester un quiz avec la nouvelle catégorie
- [ ] Tester les flashcards de la nouvelle catégorie
- [ ] **Si images** → Tester que les images s'affichent
- [ ] **Si images** → Tester pinch-to-zoom et double-tap

---

## 📞 Support

Si la catégorie n'apparaît toujours pas après avoir suivi toutes les étapes :

1. Vérifiez les logs Flutter dans le terminal
2. Vérifiez qu'il n'y a pas d'erreur YAML (indentation, syntaxe)
3. Vérifiez que le nom du dossier correspond exactement à celui dans `pubspec.yaml`
4. **Pour images** : Vérifiez le chemin dans YAML et dans `pubspec.yaml`
5. Essayez un `flutter clean` puis `flutter run`

---

## 📚 Documentation complémentaire

Pour plus de détails sur les images :
- 📖 `IMAGES_LOCAL_REMOTE.md` - Guide complet images
- 📖 `README_IMAGES.md` - Quick start images
- 📖 `GUIDE_IMAGE_INTEGRATION.md` - Intégration dans QuizScreen
- 📖 `assets/data/IMAGE_QUESTIONS_FORMAT.yaml` - Exemples YAML

---

**✅ C'est tout ! Votre nouvelle catégorie avec (ou sans) images devrait maintenant être disponible dans l'application.**

````
