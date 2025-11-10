# 👨‍💼 GUIDE ADMINISTRATEUR - Gestion des Catégories et Questions

**Pour les administrateurs qui créent/modifient les catégories et questions**

---

## 📋 Table des matières
1. [Créer une nouvelle catégorie](#créer-une-nouvelle-catégorie)
2. [Créer des questions](#créer-des-questions)
3. [Ajouter des images](#ajouter-des-images)
4. [Modifier une catégorie](#modifier-une-catégorie)
5. [Modifier des questions](#modifier-des-questions)
6. [Supprimer une catégorie](#supprimer-une-catégorie)
7. [Supprimer des questions](#supprimer-des-questions)
8. [Validation & Troubleshooting](#validation--troubleshooting)

---

## ✏️ Créer une nouvelle catégorie

### Étape 1: Créer la structure de dossiers

1. Ouvrir l'explorateur de fichiers
2. Aller dans: `assets/data/`
3. Créer un nouveau dossier avec le nom de votre catégorie
   - **Format**: `MaCategorie` (PascalCase, pas d'espaces)
   - **Exemples valides**: `Reseaux`, `Securite`, `BaseDeDonnees`
   - **❌ Exemples invalides**: `Ma Categorie`, `ma-categorie`, `RESEAUX`

### Étape 2: Créer les fichiers YAML

Créer 2 fichiers dans le dossier:

#### `questions.yaml`
```yaml
# Contient la liste des questions

- id: cat_q_001
  question: "Quelle est la définition de X?"
  options:
    - Option A
    - Option B
    - Option C
    - Option D
  correct_answers:
    - Option A
  explanation: "Explication détaillée ici"
  hint: "Indice optionnel"
  category: MaCategorie
  difficulty: facile
  question_type: single
  points: 1
  tags:
    - concept1
    - concept2
  reference: "Livre p.123"

- id: cat_q_002
  question: "Sélectionnez TOUTES les bonnes réponses:"
  options:
    - Réponse 1
    - Réponse 2
    - Réponse 3
    - Réponse 4
  correct_answers:
    - Réponse 1
    - Réponse 3
  explanation: "..."
  category: MaCategorie
  difficulty: moyen
  question_type: multiple
  points: 2
  # ... autres questions
```

#### `flashcards.yaml` (optionnel mais recommandé)
```yaml
# Cartes pour révision rapide

- id: card_001
  front: "Question courte?"
  back: "Réponse courte"
  category: MaCategorie

- id: card_002
  front: "Autre question?"
  back: "Autre réponse"
  category: MaCategorie
```

### Étape 3: Déclarer dans pubspec.yaml

1. Ouvrir `pubspec.yaml` à la racine du projet
2. Localiser la section `assets:`
3. Ajouter votre catégorie (sur 2 lignes):

```yaml
flutter:
  assets:
    # Catégories existantes...
    - assets/data/MaCategorie/               # ← YAML files
    - assets/images/MaCategorie/             # ← Images (si besoin)
```

### Étape 4: Recompiler l'app

```bash
# En développement
flutter pub get
flutter run -d linux

# Pour APK production
flutter build apk --release
```

✅ La catégorie est maintenant disponible dans l'app!

---

## ✏️ Créer des questions

### Format YAML obligatoire

```yaml
- id: categorie_q_NNN
  question: "Texte de la question?"
  options:
    - Option A
    - Option B
    - Option C
    - Option D
  correct_answers:
    - Option A
  explanation: "Pourquoi c'est juste"
  category: MaCategorie
  difficulty: facile | moyen | difficile
  question_type: single | multiple
  points: 1 | 2 | 3
```

### Champs obligatoires vs optionnels

| Champ | Type | Obligatoire? | Exemple |
|-------|------|-------------|---------|
| `id` | String | ✅ OUI | `net_q_001` |
| `question` | String | ✅ OUI | `"Qu'est-ce qu'une adresse IP?"` |
| `options` | List | ✅ OUI | `["A", "B", "C", "D"]` |
| `correct_answers` | List | ✅ OUI | `["A"]` ou `["A", "C"]` |
| `explanation` | String | ✅ OUI | `"Une adresse IP est..."` |
| `category` | String | ✅ OUI | Même que dossier |
| `difficulty` | String | ✅ OUI | `facile` / `moyen` / `difficile` |
| `question_type` | String | ✅ OUI | `single` ou `multiple` |
| `points` | Int | ✅ OUI | `1` ou `2` ou `3` |
| `hint` | String | ❌ Optionnel | `"Penser à..."` |
| `tags` | List | ❌ Optionnel | `["tcp", "réseau"]` |
| `reference` | String | ❌ Optionnel | `"RFC 791"` |
| `images` | List | ❌ Optionnel | Voir [Ajouter des images](#ajouter-des-images) |

### Exemple complet avec tous les champs

```yaml
- id: net_q_001
  question: "Quel type d'architecture réseau est illustré par ce schéma?"
  options:
    - Architecture bus
    - Architecture maille
    - Architecture en étoile
    - Architecture hiérarchique
  correct_answers:
    - Architecture bus
  explanation: |
    Une architecture bus connecte tous les appareils à un cable central.
    Les autres appareils reçoivent tous les messages (broadcast).
  hint: "Regardez le schéma: tous les appareils sont sur la même ligne"
  category: Reseaux
  difficulty: facile
  question_type: single
  points: 1
  tags:
    - topologie
    - architecture-réseau
  reference: "Chapitre 3, section 3.2"
  images:
    - id: img_net_001_1
      label: "Architecture Bus"
      source: "assets/images/Reseaux/network_bus.png"
      description: "Vue de l'architecture en bus"
    - id: img_net_001_2
      label: "Architecture Étoile"
      source: "assets/images/Reseaux/network_star.png"
      description: "Vue de l'architecture en étoile"
```

### Règles importantes

✅ **IDs uniques:**
- Chaque question doit avoir un `id` UNIQUE dans la catégorie
- Format: `categorie_q_NNN` (ex: `net_q_001`, `sec_q_042`)

✅ **correct_answers doit matcher options:**
```yaml
options: ["A", "B", "C"]
correct_answers: ["A"]  ✅ OK - "A" existe dans options

correct_answers: ["D"]  ❌ ERREUR - "D" n'existe pas
```

✅ **Difficultés valides:**
- `facile`
- `moyen`
- `difficile`

✅ **Types questions:**
- `single` : 1 seule bonne réponse (radio button)
- `multiple` : Plusieurs bonnes réponses (checkboxes)

❌ **Erreurs courantes:**
```yaml
# ❌ MAUVAIS - pas de tiret avant id
id: net_q_001
question: "..."

# ✅ BON - tiret + espace
- id: net_q_001
  question: "..."

# ❌ MAUVAIS - indentation incorrecte
- id: net_q_001
question: "..."

# ✅ BON - indentation 2 espaces
- id: net_q_001
  question: "..."

# ❌ MAUVAIS - options n'est pas une liste
options: "A, B, C"

# ✅ BON - options est une liste
options:
  - A
  - B
  - C
```

---

## 🖼️ Ajouter des images

### Étape 1: Préparer les images

1. **Format:** PNG recommandé (JPG accepté)
2. **Taille:** 800x600 px minimum (optimiser pour performance)
3. **Nom:** descriptif, pas d'espaces
   - ✅ `network_bus.png`
   - ❌ `reseau 1.png`

### Étape 2: Placer les images locales

1. Créer: `assets/images/MaCategorie/`
2. Copier PNG/JPG dans ce dossier
3. Exemple:
   ```
   assets/images/Reseaux/
   ├── network_bus.png
   ├── network_star.png
   └── network_mesh.png
   ```

### Étape 3: Déclarer dans pubspec.yaml

```yaml
flutter:
  assets:
    - assets/data/MaCategorie/
    - assets/images/MaCategorie/              # ← AJOUTER CETTE LIGNE
```

### Étape 4: Ajouter images à la question YAML

Option A: **Image locale (fichier PNG)**
```yaml
- id: net_q_001
  question: "Quel type d'architecture?"
  options: ["Bus", "Étoile"]
  correct_answers: ["Bus"]
  explanation: "..."
  category: Reseaux
  difficulty: facile
  question_type: single
  points: 1
  images:
    - id: img_net_001_1
      label: "Bus"
      source: "assets/images/Reseaux/network_bus.png"
      description: "Tous les devices sur la même ligne"
    - id: img_net_001_2
      label: "Étoile"
      source: "assets/images/Reseaux/network_star.png"
      description: "Hub central avec branches"
```

Option B: **Image web (URL)**
```yaml
images:
  - id: img_wiki_001
    label: "OSI Model"
    source: "https://upload.wikimedia.org/wikipedia/commons/8/8d/OSI_model_layers.png"
    description: "Modèle OSI - 7 couches"
```

Option C: **Mélanger local + web**
```yaml
images:
  - id: img_local
    label: "Schéma local"
    source: "assets/images/Reseaux/schema.png"
    description: "Notre schéma"
  - id: img_web
    label: "Référence web"
    source: "https://example.com/image.png"
    description: "Image de référence"
```

### 🎯 Au runtime:
1. Question s'affiche
2. Boutons images: **[Bus] [Étoile]**
3. User click → Fullscreen dialog
4. Scroll, zoom (pinch), close

---

## 🔧 Modifier une catégorie

### Renommer une catégorie

⚠️ **COMPLEXE** - Mieux vaut créer nouvelle et supprimer l'ancienne

**Étapes:**
1. Créer nouvelle catégorie avec nouveau nom
2. Copier tous les `questions.yaml` + images
3. Mettre à jour `category:` dans chaque question YAML
4. Déclarer dans `pubspec.yaml`
5. Supprimer ancienne catégorie
6. Recompiler APK

### Ajouter des images à une catégorie existante

1. Créer dossier: `assets/images/MaCategorie/` (si n'existe pas)
2. Copier images PNG
3. Ajouter à `pubspec.yaml`:
   ```yaml
   - assets/images/MaCategorie/
   ```
4. Éditer `questions.yaml` pour ajouter champ `images:`
5. Recompiler

---

## ✏️ Modifier des questions

### Modifier le texte/réponses

1. Ouvrir `assets/data/MaCategorie/questions.yaml`
2. Localiser la question par `id:`
3. Éditer les champs:

```yaml
# AVANT
- id: net_q_001
  question: "Vieille question?"
  explanation: "Vieille explication"

# APRÈS
- id: net_q_001
  question: "Nouvelle question?"
  explanation: "Nouvelle explication"
```

4. **Mode développement:**
   ```bash
   # Hot-reload (modifications immédiatement visibles)
   flutter run -d linux
   # Puis press 'r' dans terminal
   ```

5. **Mode APK:**
   ```bash
   # Recompiler nécessaire
   flutter build apk --release
   ```

### Changer la difficulté

```yaml
# Avant
difficulty: facile

# Après
difficulty: moyen
```

### Ajouter/supprimer une bonne réponse

```yaml
# Avant (single - 1 réponse)
question_type: single
correct_answers: ["A"]

# Après (multiple - 2 réponses)
question_type: multiple
correct_answers: ["A", "C"]
```

⚠️ **Important:** Changer `question_type` change le UI:
- `single` → Radio buttons
- `multiple` → Checkboxes

### Ajouter une image à une question existante

1. Placer image dans `assets/images/MaCategorie/`
2. Éditer question YAML:

```yaml
- id: net_q_001
  question: "..."
  options: [...]
  # ... autres champs ...
  images:                    # ← AJOUTER CETTE SECTION
    - id: img_001
      label: "Schéma"
      source: "assets/images/Reseaux/new_image.png"
      description: "Description"
```

---

## 🗑️ Supprimer une catégorie

### Étape 1: Backup (optionnel mais recommandé)
```bash
cp -r assets/data/MaCategorie assets/data/MaCategorie.backup
```

### Étape 2: Supprimer le dossier
```bash
rm -rf assets/data/MaCategorie
rm -rf assets/images/MaCategorie    # Si images locales existent
```

### Étape 3: Éditer pubspec.yaml
Supprimer les 2 lignes:
```yaml
# AVANT
flutter:
  assets:
    - assets/data/MaCategorie/
    - assets/images/MaCategorie/

# APRÈS
flutter:
  assets:
    # Autre catégorie...
```

### Étape 4: Recompiler
```bash
flutter pub get
flutter run -d linux
```

✅ Catégorie disparue de l'app

---

## 🗑️ Supprimer des questions

### Supprimer UNE question

1. Ouvrir `assets/data/MaCategorie/questions.yaml`
2. Supprimer le bloc de la question (du tiret `-` jusqu'à la prochaine question)

```yaml
# AVANT
- id: net_q_001
  question: "..."
  ...
- id: net_q_002
  question: "À garder"
  ...

# APRÈS (supprimer net_q_001 complètement)
- id: net_q_002
  question: "À garder"
  ...
```

### Supprimer PLUSIEURS questions

**Méthode rapide:** 
1. Éditer questions.yaml
2. Supprimer les blocs complets
3. Garder l'indentation correcte
4. Recompiler

**Vérifier YAML valide:**
```bash
# Vérifier pas d'erreur de syntaxe
flutter analyze
```

---

## ✅ Validation & Troubleshooting

### Validation: Questions valides?

**Checklist pour chaque question:**
- [ ] `id:` unique dans la catégorie
- [ ] `question:` non-vide
- [ ] `options:` liste avec ≥2 éléments
- [ ] `correct_answers:` items existent dans options
- [ ] `explanation:` non-vide
- [ ] `category:` = nom du dossier
- [ ] `difficulty:` ∈ [facile, moyen, difficile]
- [ ] `question_type:` ∈ [single, multiple]
- [ ] `points:` ∈ [1, 2, 3]
- [ ] Si `question_type: multiple` → `correct_answers:` ≥ 2 items

### Validation: YAML valide?

**Problèmes courants:**

❌ **Indentation incorrecte**
```yaml
# MAUVAIS - 1 espace
- id: q_001
 question: "..."

# BON - 2 espaces
- id: q_001
  question: "..."
```

❌ **Caractères spéciaux dans YAML**
```yaml
# MAUVAIS - : dans texte
question: "C'est quoi: ceci?"

# BON - utiliser guillemets
question: "C'est quoi: ceci?"

# MEILLEUR - utiliser |
question: |
  C'est quoi: ceci?
  Ligne 2
```

❌ **Indentation liste non-uniforme**
```yaml
# MAUVAIS
options:
  - A
    - B     # ← Trop indentée

# BON
options:
  - A
  - B
```

### Vérifier YAML en ligne

Site: https://www.yamllint.com/

1. Copier contenu `questions.yaml`
2. Coller dans validateur
3. Voir erreurs d'indentation/format

### Erreur: "Catégorie n'apparaît pas dans l'app"

**Checklist:**
- [ ] Dossier créé dans `assets/data/`
- [ ] `pubspec.yaml` contient `- assets/data/MaCategorie/`
- [ ] `flutter pub get` exécuté
- [ ] App recompilée: `flutter run -d linux`
- [ ] `questions.yaml` existe et valide

**Solution:**
```bash
flutter clean
rm -rf build
flutter pub get
flutter run -d linux
```

### Erreur: "Questions ne s'affichent pas"

**Checklist:**
- [ ] YAML valide (pas d'indentation)
- [ ] `category:` = nom dossier exact
- [ ] Pas d'erreur dans logs:
  ```bash
  flutter run -d linux 2>&1 | grep -i error
  ```
- [ ] `question_type:` valide (single/multiple)
- [ ] `correct_answers:` items existent dans options

**Solution:**
1. Valider YAML sur yamllint.com
2. Vérifier indentation (2 espaces)
3. Recompiler: `flutter clean && flutter run -d linux`

### Erreur: "Images ne s'affichent pas"

**Checklist:**
- [ ] Images copiées dans `assets/images/MaCategorie/`
- [ ] `pubspec.yaml` contient `- assets/images/MaCategorie/`
- [ ] Chemin YAML exact: `assets/images/MaCategorie/image.png`
- [ ] Format: PNG recommandé, JPG acceptable
- [ ] Web images: URL complète avec https://

**Solution:**
```bash
# Images locales: recompiler APK
flutter build apk --release

# Web images: check URL fonctionne
# Dans navigateur: https://url-image.com/image.png
```

---

## 📞 Support

**Ressource:** Voir [legacy-doc/GUIDE_IMAGES.md](legacy-doc/GUIDE_IMAGES.md) pour détails images

**Contact:** dev team

---

**Dernière mise à jour:** 2025-11-10
**Pour:** Administrateurs créant/modifiant contenu
