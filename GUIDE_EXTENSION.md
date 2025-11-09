# 📚 Guide d'extension du Quiz App

Guide complet pour ajouter de nouvelles catégories, questions et flashcards à l'application.

---

## 🎯 Table des matières

1. [Ajouter une nouvelle catégorie](#-ajouter-une-nouvelle-catégorie)
2. [Ajouter des questions](#-ajouter-des-questions)
3. [Ajouter des flashcards](#-ajouter-des-flashcards)
4. [Structure des fichiers YAML](#-structure-des-fichiers-yaml)
5. [Bonnes pratiques](#-bonnes-pratiques)
6. [Exemple complet](#-exemple-complet)
7. [Dépannage](#-dépannage)

---

## 📁 Ajouter une nouvelle catégorie

### Étape 1 : Créer la structure de dossiers

Créez un nouveau dossier pour votre catégorie :

```bash
mkdir -p ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/nom_categorie
```

**Exemple** : Pour une catégorie "networking"
```bash
mkdir -p ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/networking
```

### Étape 2 : Créer le fichier `questions.yaml`

Dans le dossier créé, créez le fichier `questions.yaml` avec vos questions :

```bash
touch ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/nom_categorie/questions.yaml
```

### Étape 3 : Créer le fichier `flashcards.yaml` (optionnel)

```bash
touch ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/nom_categorie/flashcards.yaml
```

### Étape 4 : Mettre à jour `pubspec.yaml`

Ouvrez le fichier `/home/vrm/mobile-quiz-app/mobile-quiz-app/quiz_app/pubspec.yaml` et trouvez la section `assets` :

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/data/user_management/
    - assets/data/filesystem/
    - assets/data/service/
    - assets/data/nom_categorie/  # ← AJOUTER CETTE LIGNE
```

### Étape 5 : Mettre à jour `data_service.dart`

Ouvrez `/home/vrm/mobile-quiz-app/mobile-quiz-app/quiz_app/lib/services/data_service.dart` et modifiez la méthode `getAvailableCategories()` :

```dart
static Future<List<String>> getAvailableCategories() async {
  final List<String> allCategories = [
    'user_management',
    'filesystem',
    'service',
    'nom_categorie',  // ← AJOUTER CETTE LIGNE
  ];
  
  // ...reste du code
}
```

### Étape 6 : Relancer l'application

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d linux
```

> **Note** : Après avoir modifié `pubspec.yaml`, un redémarrage complet est nécessaire (pas juste un hot reload).

---

## 📝 Ajouter des questions

### Format de base

Ouvrez le fichier `questions.yaml` de votre catégorie et ajoutez des questions :

```yaml
- id: "cat_001"
  question: "Votre question ?"
  options:
    - "Option 1 (correcte)"
    - "Option 2 (incorrecte)"
    - "Option 3 (incorrecte)"
    - "Option 4 (incorrecte)"
  correct_answers:
    - "Option 1 (correcte)"
  explanation: "Explication détaillée de pourquoi c'est la bonne réponse."
  hint: "Un indice utile pour aider l'utilisateur"
  category: "nom_categorie"
  difficulty: "facile"
  question_type: "single"
  points: 1
  tags:
    - "tag1"
    - "tag2"
  reference: "https://lien-vers-documentation.com"
```

### Paramètres détaillés

| Paramètre | Type | Obligatoire | Description |
|-----------|------|-------------|-------------|
| `id` | String | ✅ | Identifiant unique de la question (ex: `cat_001`) |
| `question` | String | ✅ | Le texte de la question |
| `options` | List[String] | ✅ | Liste de 4 options de réponse |
| `correct_answers` | List[String] | ✅ | Liste des réponses correctes |
| `explanation` | String | ✅ | Explication détaillée |
| `hint` | String | ❌ | Indice optionnel |
| `category` | String | ✅ | Doit correspondre au nom du dossier |
| `difficulty` | String | ✅ | `facile`, `moyen`, ou `difficile` |
| `question_type` | String | ✅ | `single` (une réponse) ou `multiple` (plusieurs) |
| `points` | Integer | ✅ | Nombre de points (généralement 1) |
| `tags` | List[String] | ❌ | Tags pour catégoriser |
| `reference` | String | ❌ | Lien vers documentation |

### Exemple : Questions à choix multiple

Pour permettre plusieurs réponses correctes :

```yaml
- id: "cat_002"
  question: "Quelles sont les commandes pour créer un utilisateur ?"
  options:
    - "useradd"
    - "adduser"
    - "createuser"
    - "newuser"
  correct_answers:
    - "useradd"
    - "adduser"
  explanation: "useradd est la commande bas-niveau, adduser est un wrapper convivial."
  category: "nom_categorie"
  difficulty: "moyen"
  question_type: "multiple"
  points: 1
```

---

## 💾 Ajouter des flashcards

### Format de base

Ouvrez le fichier `flashcards.yaml` de votre catégorie et ajoutez des flashcards :

```yaml
- id: "cat_f001"
  term: "Terme ou concept à mémoriser"
  explanation: "Explication détaillée du concept"
  example: "Exemple de commande ou d'utilisation"
  category: "nom_categorie"
```

### Paramètres détaillés

| Paramètre | Type | Obligatoire | Description |
|-----------|------|-------------|-------------|
| `id` | String | ✅ | Identifiant unique (ex: `cat_f001`) |
| `term` | String | ✅ | Le concept/terme à mémoriser |
| `explanation` | String | ✅ | Explication complète |
| `example` | String | ❌ | Exemple concret d'utilisation |
| `category` | String | ✅ | Doit correspondre au nom du dossier |

### Exemple : Flashcard avec exemple

```yaml
- id: "net_f001"
  term: "IP Address"
  explanation: "Adresse IP Protocol identifie un appareil sur un réseau. IPv4 utilise 4 octets (0-255), IPv6 utilise 128 bits."
  example: "192.168.1.1 (IPv4) ou 2001:db8::1 (IPv6)"
  category: "networking"

- id: "net_f002"
  term: "Subnet Mask"
  explanation: "Masque de sous-réseau qui détermine quelle partie de l'IP est l'adresse réseau et quelle partie est l'hôte."
  example: "255.255.255.0 signifie les 3 premiers octets sont le réseau"
  category: "networking"
```

---

## 🔍 Structure des fichiers YAML

### Règles d'indentation

Le YAML est sensible à l'indentation. Utilisez **2 espaces** (pas de tabs) :

```yaml
# ❌ INCORRECT - Indentation incohérente
- id: "cat_001"
   question: "Question"  # 3 espaces, c'est mal !
  options:
    - "Option"

# ✅ CORRECT - Indentation cohérente
- id: "cat_001"
  question: "Question"  # 2 espaces
  options:
    - "Option"  # 4 espaces (2 de base + 2 pour la liste)
```

### Échapper les caractères spéciaux

Utilisez des guillemets pour les textes contenant des caractères spéciaux :

```yaml
# ❌ INCORRECT
question: Qu'est-ce qu'un fichier /etc/passwd ?

# ✅ CORRECT
question: "Qu'est-ce qu'un fichier /etc/passwd ?"
```

### Multilignes

Pour du texte long, utilisez le symbole `|` :

```yaml
explanation: |
  Ceci est une explication multilignes.
  Elle peut s'étendre sur plusieurs lignes.
  Et être plus lisible dans le YAML.
```

---

## ✅ Bonnes pratiques

### 1. **Nommage des IDs**

- Commencez par les initiales de la catégorie
- Suivi d'un underscore et d'un numéro
- Exemples :
  - `usr_001`, `usr_002` (user_management)
  - `fs_001`, `fs_002` (filesystem)
  - `net_001`, `net_002` (networking)
  - `net_f001` (flashcard networking)

### 2. **Uniformité des catégories**

Toutes les questions d'une catégorie doivent avoir le même nom :

```yaml
# ❌ INCORRECT - Noms différents
category: "networking"
category: "Network"
category: "net"

# ✅ CORRECT - Même nom partout
category: "networking"
```

### 3. **Niveau de difficulté**

Distribuez vos questions :
- 30-40% : `facile`
- 40-50% : `moyen`
- 10-20% : `difficile`

### 4. **Explications claires**

Chaque explication doit :
- Répondre au "pourquoi" et pas seulement au "quoi"
- Être concise (1-3 phrases)
- Inclure des contextes pratiques

### 5. **Ordre des flashcards**

Les flashcards ne sont PAS randomisées. Ordonnez-les logiquement :
1. Les concepts de base en premier
2. Les concepts avancés après
3. Progressif et pédagogique

### 6. **Validation avant commit**

Avant de relancer l'app, vérifiez :
- ✅ Les IDs sont uniques
- ✅ Les catégories correspondent
- ✅ L'indentation YAML est correcte
- ✅ Les listes `correct_answers` correspondent à `options`

---

## 🔧 Exemple complet

### Exemple : Ajouter une catégorie "Networking"

#### 1. Créer la structure
```bash
mkdir -p ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/networking
```

#### 2. Créer `questions.yaml`
Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/networking/questions.yaml`

```yaml
- id: "net_001"
  question: "Qu'est-ce qu'une adresse IP ?"
  options:
    - "Un identifiant unique pour un appareil sur un réseau"
    - "Un type de protocole réseau"
    - "Une adresse MAC"
    - "Un numéro de port"
  correct_answers:
    - "Un identifiant unique pour un appareil sur un réseau"
  explanation: "Une adresse IP (Internet Protocol) identifie de manière unique un appareil sur un réseau. IPv4 utilise 32 bits (4 octets), IPv6 utilise 128 bits."
  hint: "Pense à l'identifiant unique..."
  category: "networking"
  difficulty: "facile"
  question_type: "single"
  points: 1
  tags:
    - "fondamentaux"
    - "ipv4"
  reference: "https://en.wikipedia.org/wiki/IP_address"

- id: "net_002"
  question: "Que signifie CIDR 192.168.1.0/24 ?"
  options:
    - "256 adresses disponibles (192.168.1.0 à 192.168.1.255)"
    - "24 adresses disponibles"
    - "192 adresses disponibles"
    - "Impossible à déterminer"
  correct_answers:
    - "256 adresses disponibles (192.168.1.0 à 192.168.1.255)"
  explanation: "CIDR /24 signifie que les 24 premiers bits sont le réseau, et 32-24=8 bits pour les hôtes. 2^8 = 256 adresses (0-255)."
  category: "networking"
  difficulty: "moyen"
  question_type: "single"
  points: 1
  tags:
    - "subnetting"
    - "ipv4"
```

#### 3. Créer `flashcards.yaml`
Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/networking/flashcards.yaml`

```yaml
- id: "net_f001"
  term: "IP Address"
  explanation: "Identifie un appareil sur un réseau. IPv4 = 32 bits (4 octets), IPv6 = 128 bits."
  example: "192.168.1.1 (IPv4) ou 2001:db8::1 (IPv6)"
  category: "networking"

- id: "net_f002"
  term: "Subnet Mask"
  explanation: "Détermine quelle partie de l'IP est le réseau et quelle partie est l'hôte."
  example: "255.255.255.0 = les 3 premiers octets sont le réseau"
  category: "networking"

- id: "net_f003"
  term: "CIDR Notation"
  explanation: "Format compact pour spécifier une plage d'adresses IP. /24 = 256 adresses."
  example: "192.168.1.0/24 contient 256 adresses"
  category: "networking"
```

#### 4. Mettre à jour `pubspec.yaml`
```yaml
assets:
  - assets/data/user_management/
  - assets/data/filesystem/
  - assets/data/service/
  - assets/data/networking/  # ← NOUVELLE LIGNE
```

#### 5. Mettre à jour `data_service.dart`
```dart
static Future<List<String>> getAvailableCategories() async {
  final List<String> allCategories = [
    'user_management',
    'filesystem',
    'service',
    'networking',  # ← NOUVELLE LIGNE
  ];
  // ... reste du code
}
```

#### 6. Relancer l'app
```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d linux
```

---

## 🐛 Dépannage

### La catégorie n'apparaît pas

**Solution** :
1. Vérifiez que le dossier existe : `ls ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/nom_categorie/`
2. Vérifiez que `pubspec.yaml` a été mis à jour
3. Vérifiez que `data_service.dart` a été mis à jour
4. ⚠️ Relancez l'app complètement (ne pas utiliser hot reload) :
   ```bash
   ~/flutter/bin/flutter run -d linux
   ```

### Les questions n'apparaissent pas

**Causes possibles** :
- Le fichier `questions.yaml` est vide ou inexistant
- L'indentation YAML est incorrecte
- La catégorie dans le YAML ne correspond pas au dossier
- Les IDs ne sont pas uniques

**Solution** :
1. Vérifiez le format YAML avec un validateur : https://www.yamllint.com/
2. Vérifiez la catégorie : `grep "category:" questions.yaml`
3. Vérifiez les IDs uniques : `grep "id:" questions.yaml | sort | uniq -d`

### Erreur de parsing YAML

**Cause** : Indentation incorrecte

**Solution** :
```bash
# Vérifier l'indentation
cat -A ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/data/nom_categorie/questions.yaml | head -20
# Les espaces doivent être réguliers (pas de mélange espaces/tabs)
```

---

## 📞 Support

Pour toute question ou problème, consultez :
- La documentation Flutter : https://flutter.dev/docs
- Le répo du projet : https://github.com/edulabs-fr/mobile-quiz-app
- Le fichier `doc.md` du projet
