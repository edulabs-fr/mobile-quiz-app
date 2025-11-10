# Format des fichiers YAML pour les questions

## Structure d'une question

Chaque question est définie avec les champs suivants :

```yaml
- id: "q001"                          # Identifiant unique (obligatoire)
  question: "Texte de la question"    # Texte de la question (obligatoire)
  options:                            # Liste des réponses possibles (obligatoire)
    - "Option A"
    - "Option B"
    - "Option C"
    - "Option D"
  correct_answers:                    # Liste des réponses correctes (obligatoire)
    - "Option A"                      # Pour choix unique : 1 seule réponse
    - "Option B"                      # Pour choix multiples : 2+ réponses
  explanation: "Explication détaillée" # Explication après réponse (obligatoire)
  hint: "Indice facultatif"           # Indice pour aider (optionnel)
  category: "user_management"         # Catégorie de la question (obligatoire)
  difficulty: "moyen"                 # facile, moyen ou difficile (obligatoire)
  question_type: "multiple"           # "single" ou "multiple" (obligatoire)
  points: 2                           # Points attribués (obligatoire)
  tags:                               # Tags pour classification (obligatoire)
    - "utilisateurs"
    - "groupes"
  reference: "man useradd"            # Référence documentation (optionnel)
```

## Types de questions

### Question à choix unique (single)
- `question_type: "single"`
- `correct_answers` contient **1 seule réponse**
- L'interface affiche des **boutons radio** (○)
- L'utilisateur ne peut sélectionner qu'une seule option

```yaml
- id: "q001"
  question: "Quelle commande permet de créer un utilisateur ?"
  options:
    - "useradd"
    - "adduser"
    - "usermod"
    - "newuser"
  correct_answers:
    - "useradd"
  question_type: "single"
  points: 1
```

### Question à choix multiples (multiple)
- `question_type: "multiple"`
- `correct_answers` contient **2+ réponses**
- L'interface affiche des **checkboxes** (☐)
- L'utilisateur peut sélectionner plusieurs options
- **TOUTES** les bonnes réponses doivent être sélectionnées

```yaml
- id: "q003"
  question: "Quels fichiers contiennent les informations des utilisateurs ?"
  options:
    - "/etc/passwd"
    - "/etc/shadow"
    - "/etc/users"
    - "/etc/login"
  correct_answers:
    - "/etc/passwd"
    - "/etc/shadow"
  question_type: "multiple"
  points: 2
```

## Système de points

Les points permettent de valoriser différemment les questions selon leur difficulté :

- **1 point** : Questions faciles (basiques, définitions simples)
- **2 points** : Questions moyennes (compréhension, application)
- **3 points** : Questions difficiles (analyse, concepts avancés)

Le système ajuste automatiquement le score en fonction des points attribués.

## Tags

Les tags permettent de classifier les questions pour des recherches ou filtres futurs :

```yaml
tags:
  - "utilisateurs"      # Thème principal
  - "création"          # Action concernée
  - "commandes"         # Type de connaissance
```

Suggestions de tags :
- **Thèmes** : utilisateurs, groupes, permissions, fichiers, systèmes
- **Actions** : création, modification, suppression, consultation
- **Types** : commandes, concepts, fichiers, options

## Référence (optionnel)

Le champ `reference` permet d'indiquer où trouver plus d'informations :

```yaml
reference: "man useradd"           # Page de manuel
reference: "https://linux.die.net" # Documentation en ligne
reference: "RHCSA Guide, p.45"     # Livre / Guide
```

## Difficultés

Trois niveaux de difficulté sont disponibles :

- **facile** : Concepts de base, commandes simples (icône 😊, vert)
- **moyen** : Application pratique, options avancées (icône 😐, orange)
- **difficile** : Concepts complexes, troubleshooting (icône 😞, rouge)

## Catégories disponibles

Les fichiers YAML sont organisés par catégorie dans `assets/data/` :

```
assets/data/
├── user_management/
│   └── questions.yaml
├── filesystem/
│   └── questions.yaml
├── networking/
│   └── questions.yaml
└── security/
    └── questions.yaml
```

Chaque catégorie doit contenir **au moins 10 questions** pour être affichée dans l'application.

## Validation automatique

L'application détecte automatiquement le type de question :
- Si `correct_answers` contient **1 élément** → Choix unique
- Si `correct_answers` contient **2+ éléments** → Choix multiples

Vous pouvez donc omettre `question_type` si vous préférez, il sera déduit automatiquement.

## Exemple complet

```yaml
questions:
  # Question facile à choix unique (1 point)
  - id: "q001"
    question: "Quelle commande permet de créer un nouvel utilisateur sous Linux ?"
    options:
      - "useradd"
      - "adduser"
      - "newuser"
      - "createuser"
    correct_answers:
      - "useradd"
    explanation: "La commande useradd est la commande standard pour créer un utilisateur."
    hint: "C'est une commande système de bas niveau"
    category: "user_management"
    difficulty: "facile"
    question_type: "single"
    points: 1
    tags:
      - "utilisateurs"
      - "création"
      - "commandes"
    reference: "man useradd"

  # Question moyenne à choix multiples (2 points)
  - id: "q003"
    question: "Quels fichiers contiennent les informations des utilisateurs Linux ?"
    options:
      - "/etc/passwd"
      - "/etc/shadow"
      - "/etc/users"
      - "/etc/login"
    correct_answers:
      - "/etc/passwd"
      - "/etc/shadow"
    explanation: "/etc/passwd contient les infos publiques, /etc/shadow les mots de passe."
    category: "user_management"
    difficulty: "moyen"
    question_type: "multiple"
    points: 2
    tags:
      - "utilisateurs"
      - "fichiers"
      - "système"

  # Question difficile à choix multiples (3 points)
  - id: "q010"
    question: "Quelles options de useradd permettent de définir le shell et le répertoire home ?"
    options:
      - "-s (--shell)"
      - "-d (--home-dir)"
      - "-h (--home)"
      - "-c (--comment)"
    correct_answers:
      - "-s (--shell)"
      - "-d (--home-dir)"
    explanation: "-s définit le shell par défaut et -d le répertoire home."
    category: "user_management"
    difficulty: "difficile"
    question_type: "multiple"
    points: 3
    tags:
      - "utilisateurs"
      - "options"
      - "configuration"
    reference: "man useradd"
```

## Bonnes pratiques

1. **Identifiants uniques** : Utilisez un préfixe par catégorie (ex: `um_001` pour user_management)
2. **Questions claires** : Formulez des questions précises et sans ambiguïté
3. **Options plausibles** : Les mauvaises réponses doivent être crédibles
4. **Explications détaillées** : Expliquez pourquoi la réponse est correcte
5. **Tags pertinents** : 2-4 tags par question suffisent
6. **Références utiles** : Ajoutez des références pour approfondir
7. **Équilibre des difficultés** : Mélangez les niveaux pour varier l'apprentissage
8. **Points cohérents** : Alignez les points avec la difficulté réelle
