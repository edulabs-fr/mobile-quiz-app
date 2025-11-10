# 🔄 Migration YAML: asset_path → source

## 📌 Résumé des changements

Pour supporter les **images locales ET distantes**, le format YAML des questions a changé:

### Avant
```yaml
images:
  - id: "img_001_1"
    label: "Architecture Bus"
    asset_path: "assets/images/network_bus.png"  # ❌ Ancien format
    description: "..."
```

### Après
```yaml
images:
  - id: "img_001_1"
    label: "Architecture Bus"
    source: "assets/images/Réseaux/network_bus.png"  # ✅ Nouveau format
    description: "..."
```

## 🔑 Points importants

1. **`asset_path:` → `source:`**
   - Accepte maintenant URLs ET chemins locaux
   - Le système détecte automatiquement le type

2. **Pour images locales:**
   ```yaml
   source: "assets/images/Réseaux/network_star.png"
   ```

3. **Pour images distantes (nouvelles possibilités):**
   ```yaml
   source: "https://example.com/diagram.png"
   source: "https://www.museeinformatique.fr/images/reseau.jpg"
   ```

## 📋 Checklist de migration

Si vous avez déjà des questions avec images:

- [ ] Ouvrir `assets/data/CATEGORIE/questions.yaml`
- [ ] Chercher `asset_path:`
- [ ] Remplacer par `source:`
- [ ] Optionnel: Ajouter des images distantes mélangées

## 🔁 Rétrocompatibilité

Le code Dart supporte **les deux formats**:

```dart
// Dans QuestionImage.fromYaml()
final source = yaml['source'] as String? ?? yaml['asset_path'] as String;
// ↑ Essaie 'source' en premier, fallback sur 'asset_path'
```

**Donc:**
- ✅ Ancien format `asset_path:` fonctionne encore
- ✅ Nouveau format `source:` fonctionne
- ⚠️ Recommandé: Migrer vers `source:` pour cohérence

## 📝 Exemple complet migré

### Avant (ancien format)
```yaml
- id: "img_q001"
  question: "Choisissez l'architecture..."
  images:
    - id: "img_001_1"
      label: "Bus"
      asset_path: "assets/images/network_bus.png"
      description: "Architecture bus"
    
    - id: "img_001_2"
      label: "Star"
      asset_path: "assets/images/network_star.png"
      description: "Architecture étoile"
  
  options: ["Bus", "Star"]
  correct_answers: ["Star"]
  category: "Réseaux"
  difficulty: "facile"
```

### Après (nouveau format)
```yaml
- id: "img_q001"
  question: "Choisissez l'architecture..."
  images:
    - id: "img_001_1"
      label: "Bus (local)"
      source: "assets/images/Réseaux/network_bus.png"
      description: "Architecture bus"
    
    - id: "img_001_2"
      label: "Star (web)"
      source: "https://example.com/network_star.png"
      description: "Architecture étoile depuis le serveur"
  
  options: ["Bus", "Star"]
  correct_answers: ["Star"]
  category: "Réseaux"
  difficulty: "facile"
```

## 🚀 Avantages du nouveau format

| Aspect | Avant | Après |
|--------|-------|-------|
| Images locales | ✅ | ✅ |
| Images distantes | ❌ | ✅ |
| Mélange local+web | ❌ | ✅ |
| Détection automatique | ❌ | ✅ |
| Flexibilité | Limitée | Complète |

## ✅ Tester après migration

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app

# Valider le YAML
python3 << 'EOF'
import yaml
with open('assets/data/Réseaux/questions.yaml', 'r', encoding='utf-8') as f:
    data = yaml.safe_load(f)
    for q in data:
        if 'images' in q:
            for img in q['images']:
                assert 'source' in img or 'asset_path' in img
                print(f"✓ {img['id']}: {img.get('source', img.get('asset_path'))}")
print("✓ Migration valide!")
EOF

# Tester l'app
flutter run -d linux
```

## 🔗 Voir aussi

- 📖 `IMAGES_LOCAL_REMOTE.md` - Guide complet des images
- 📖 `assets/data/IMAGE_QUESTIONS_FORMAT.yaml` - Exemples YAML
