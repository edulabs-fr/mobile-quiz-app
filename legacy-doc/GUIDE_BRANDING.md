# 🎨 Guide : Changer le Logo et le Nom de l'Application

Guide complet pour personnaliser votre application Quiz avec votre propre logo et nom.

---

## 📋 Table des matières

1. [Changer le nom de l'application](#-changer-le-nom-de-lapplication)
2. [Changer le logo (icon)](#-changer-le-logo-icon)
3. [Créer un logo à partir de zéro](#-créer-un-logo-à-partir-de-zéro)
4. [Générer les différentes résolutions](#-générer-les-différentes-résolutions)
5. [Changer le splashscreen](#-changer-le-splashscreen)
6. [Changer le package name](#-changer-le-package-name)
7. [Résumé des fichiers à modifier](#-résumé-des-fichiers-à-modifier)

---

## 📝 Changer le nom de l'application

Le nom de l'application apparaît sous l'icône sur l'écran d'accueil.

### Endroits à modifier

#### 1. **Android** - `AndroidManifest.xml`

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/AndroidManifest.xml`

Trouvez cette ligne :
```xml
<application
    android:label="quiz_app"
    ...
>
```

Remplacez `"quiz_app"` par votre nom :
```xml
<application
    android:label="Mon Quiz App"
    ...
>
```

#### 2. **iOS** - `Info.plist`

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/ios/Runner/Info.plist`

Trouvez cette clé :
```xml
<key>CFBundleDisplayName</key>
<string>quiz_app</string>
```

Remplacez par :
```xml
<key>CFBundleDisplayName</key>
<string>Mon Quiz App</string>
```

#### 3. **Flutter** - `pubspec.yaml` (optionnel, pour les métadonnées)

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/pubspec.yaml`

```yaml
name: quiz_app
description: "Quiz App pour réviser les certifications"
```

Vous pouvez mettre à jour la description, mais le `name` reste `quiz_app` (c'est le nom du package Dart).

#### 4. **Linux/Windows/macOS** - `CMakeLists.txt` ou configuration

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/linux/CMakeLists.txt`

```cmake
set(APPLICATION_TITLE "Mon Quiz App")
```

### Exemple : Changer le nom en "RHCSA Quiz"

**Android** (`AndroidManifest.xml`) :
```xml
<application
    android:label="RHCSA Quiz"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

**iOS** (`Info.plist`) :
```xml
<key>CFBundleDisplayName</key>
<string>RHCSA Quiz</string>
```

---

## 🎨 Changer le logo (icon)

Le logo apparaît en plusieurs tailles sur différentes résolutions d'appareil.

### Structure des fichiers Android

```
android/app/src/main/res/
├── mipmap-mdpi/
│   └── ic_launcher.png       (48x48 px)
├── mipmap-hdpi/
│   └── ic_launcher.png       (72x72 px)
├── mipmap-xhdpi/
│   └── ic_launcher.png       (96x96 px)
├── mipmap-xxhdpi/
│   └── ic_launcher.png       (144x144 px)
└── mipmap-xxxhdpi/
    └── ic_launcher.png       (192x192 px)
```

### Étape 1 : Préparer votre logo

Créez un logo **carré** avec les propriétés suivantes :

- ✅ Format : PNG avec transparence (RGBA)
- ✅ Taille minimale : 512x512 pixels
- ✅ Format : Carré (1:1)
- ✅ Fond : Transparent (pour pouvoir être utilisé sur n'importe quel fond)

**Conseil** : Utilisez un des outils suivants :
- [Figma](https://www.figma.com) - Gratuit et en ligne
- [GIMP](https://www.gimp.org) - Logiciel gratuit et puissant
- [Inkscape](https://inkscape.org) - Pour les logos vectoriels
- [Canva](https://www.canva.com) - Templates gratuits

### Étape 2 : Générer les différentes résolutions

#### Option A : Utiliser `flutter_launcher_icons` (recommandé)

**Avantage** : Automatique et simple

1. **Créer le fichier de configuration**

Créez un fichier `pubspec.yaml` dans la section `dev_dependencies` :

```yaml
dev_dependencies:
  flutter_launcher_icons: "^0.13.1"

flutter_icons:
  android: "launcher_icon"
  image_path: "assets/icon/app_icon.png"
  # ou pour une version adaptée Android
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

2. **Placer votre logo**

Créez le dossier et placez votre logo :
```bash
mkdir -p ~/mobile-quiz-app/mobile-quiz-app/quiz_app/assets/icon
# Copiez votre logo ici : app_icon.png (512x512 minimum)
```

3. **Générer les icons**

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter pub run flutter_launcher_icons
```

**Résultat** : Tous les fichiers sont générés automatiquement ! ✅

#### Option B : Générer manuellement avec ImageMagick

```bash
# Installer ImageMagick
sudo apt-get install imagemagick

# Générer toutes les résolutions depuis un logo 512x512
convert app_icon.png -resize 48x48 android/app/src/main/res/mipmap-mdpi/ic_launcher.png
convert app_icon.png -resize 72x72 android/app/src/main/res/mipmap-hdpi/ic_launcher.png
convert app_icon.png -resize 96x96 android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
convert app_icon.png -resize 144x144 android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
convert app_icon.png -resize 192x192 android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
```

#### Option C : Site en ligne

Utilisez un site comme [App Icon Generator](https://appicon.co/) :
1. Uploadez votre logo 512x512
2. Téléchargez le fichier ZIP
3. Décompressez et copiez les fichiers dans `android/app/src/main/res/`

### Étape 3 : Remplacer les fichiers

Si vous générez manuellement, placez les fichiers :

```bash
# Exemple : Si vous avez les fichiers PNG prêts
cp /chemin/vers/48x48.png ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp /chemin/vers/72x72.png ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp /chemin/vers/96x96.png ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp /chemin/vers/144x144.png ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
cp /chemin/vers/192x192.png ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
```

### Étape 4 : Vérifier les permissions

```bash
# Vérifier que les fichiers existent
ls -la ~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/mipmap-*/ic_launcher.png
```

### Étape 5 : Relancer l'application

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter clean
~/flutter/bin/flutter run
```

⚠️ **Important** : Après avoir changé les icons, un `flutter clean` est nécessaire !

---

## 🎨 Créer un logo à partir de zéro

### Recommandations de design

Pour un quiz/app d'apprentissage, les meilleurs logos sont :

1. **Minimaliste** ✅
   - Logo simple et reconnaissable à petite taille
   - Utilise 2-3 couleurs maximum
   - Évite les détails complexes

2. **Couleurs** 🎨
   - Couleurs vives et contrastées
   - Respecte votre branding (ex: Red Hat = rouge)
   - Lisible sur fond blanc et transparent

3. **Formes** 🔷
   - Cercle, carré ou forme abstraite
   - Évite les formes trop complexes
   - Symétrique si possible

### Exemples de concepts pour un quiz app

| Concept | Description |
|---------|-------------|
| 📚 Livre + Ampoule | Éducation + Innovation |
| 🧠 Cerveau stylisé | Apprentissage |
| ❓ Point d'interrogation | Quiz |
| 🎯 Cible | Objectifs |
| 📊 Graphique | Progression |
| 🏆 Trophée | Achievements |

### Tutoriel rapide avec Figma

1. Allez sur https://www.figma.com
2. Créez un design 512x512 px
3. Utilisez les formes géométriques (cercles, rectangles)
4. Exportez en PNG avec transparence
5. Téléchargez et utilisez pour l'app

---

## 📱 Générer les différentes résolutions

### Résolutions requises pour Android

| Nom | DPI | Taille | Appareils |
|-----|-----|--------|-----------|
| mdpi | 160 | 48x48 | Anciens appareils |
| hdpi | 240 | 72x72 | Petits appareils |
| xhdpi | 320 | 96x96 | Appareils standard |
| xxhdpi | 480 | 144x144 | Appareils haute résolution |
| xxxhdpi | 640 | 192x192 | Appareils très haute résolution |

### Script bash pour générer automatiquement

Créez un fichier `generate_icons.sh` :

```bash
#!/bin/bash

# Script pour générer les icons depuis une image 512x512

SOURCE_IMAGE="app_icon.png"
OUTPUT_DIR="android/app/src/main/res"

# Vérifier que l'image source existe
if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Erreur : $SOURCE_IMAGE non trouvé"
    exit 1
fi

# Générer les différentes résolutions
echo "Génération des icons..."

convert "$SOURCE_IMAGE" -resize 48x48 "$OUTPUT_DIR/mipmap-mdpi/ic_launcher.png"
echo "✓ mdpi (48x48)"

convert "$SOURCE_IMAGE" -resize 72x72 "$OUTPUT_DIR/mipmap-hdpi/ic_launcher.png"
echo "✓ hdpi (72x72)"

convert "$SOURCE_IMAGE" -resize 96x96 "$OUTPUT_DIR/mipmap-xhdpi/ic_launcher.png"
echo "✓ xhdpi (96x96)"

convert "$SOURCE_IMAGE" -resize 144x144 "$OUTPUT_DIR/mipmap-xxhdpi/ic_launcher.png"
echo "✓ xxhdpi (144x144)"

convert "$SOURCE_IMAGE" -resize 192x192 "$OUTPUT_DIR/mipmap-xxxhdpi/ic_launcher.png"
echo "✓ xxxhdpi (192x192)"

echo "✅ Tous les icons ont été générés avec succès !"
```

Utilisation :

```bash
chmod +x generate_icons.sh
./generate_icons.sh
```

---

## 🎬 Changer le Splashscreen

Le splashscreen est l'écran qui s'affiche au démarrage.

### Fichiers à modifier

#### **Android**

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/android/app/src/main/res/drawable/launch_background.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/ic_launcher_background"/>
    <item
        android:drawable="@drawable/ic_launcher_foreground"
        android:gravity="center"/>
</layer-list>
```

Vous pouvez :
1. Changer la couleur de fond : `@color/ic_launcher_background`
2. Ajouter une image de splashscreen

#### **iOS**

Fichier : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/`

Remplacez les fichiers PNG par vos propres images.

---

## 🔐 Changer le Package Name

Le package name est l'identifiant unique de votre app sur Google Play.

### Fichier : `android/app/build.gradle`

```gradle
android {
    namespace = "com.edulabs.quiz_app"
    
    defaultConfig {
        applicationId = "com.edulabs.quiz_app"
```

Remplacez `com.edulabs.quiz_app` par votre package name :

```gradle
android {
    namespace = "com.example.rhcsa_quiz"
    
    defaultConfig {
        applicationId = "com.example.rhcsa_quiz"
```

### Convention de nommage

- Format : `com.nom_entreprise.nom_app`
- Exemple : `com.redhat.rhcsa_quiz`
- En minuscules
- Pas d'espaces ni de caractères spéciaux
- Doit être unique sur Google Play

### Important ⚠️

Vous ne pouvez **pas** changer le package name après avoir soumis l'app sur Google Play. Bien y réfléchir avant !

---

## 📝 Résumé des fichiers à modifier

### Changement du nom

| Platform | Fichier | Clé | Valeur actuelle | Nouvelle valeur |
|----------|---------|-----|-----------------|-----------------|
| Android | `AndroidManifest.xml` | `android:label` | `quiz_app` | `Mon Quiz App` |
| iOS | `Info.plist` | `CFBundleDisplayName` | `quiz_app` | `Mon Quiz App` |
| Linux | `linux/CMakeLists.txt` | `APPLICATION_TITLE` | `quiz_app` | `Mon Quiz App` |

### Changement du logo

| Platform | Fichiers | Action |
|----------|----------|--------|
| Android | `mipmap-*/ic_launcher.png` | Remplacer par 5 versions (48, 72, 96, 144, 192 px) |
| iOS | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` | Remplacer les fichiers PNG |
| Linux | `linux/my_application/` | Remplacer `my_application_icon.png` |
| Windows | `windows/runner/resources/app_icon.ico` | Remplacer par votre icon ICO |

### Changement du package name (avant première publication)

| Platform | Fichier | Clé | Valeur |
|----------|---------|-----|--------|
| Android | `android/app/build.gradle` | `applicationId` | `com.example.app` |
| Android | `android/app/build.gradle` | `namespace` | `com.example.app` |

---

## 🔄 Checklist de personnalisation

- [ ] Nom changé dans `AndroidManifest.xml`
- [ ] Nom changé dans `Info.plist` (iOS)
- [ ] Logo créé ou préparé (512x512 min)
- [ ] Icons générés avec `flutter_launcher_icons` OU ImageMagick
- [ ] Tous les fichiers `ic_launcher.png` remplacés
- [ ] Package name changé dans `build.gradle` (si nécessaire)
- [ ] Splashscreen personnalisé (optionnel)
- [ ] `flutter clean` exécuté
- [ ] App testée sur émulateur/appareil
- [ ] Logo visible à l'écran d'accueil ✅

---

## 🚀 Étapes complètes : Exemple concret

### Personnaliser l'app pour "AWS Quiz"

#### 1. Changer le nom

**Android** (`AndroidManifest.xml`) :
```xml
android:label="AWS Quiz"
```

**iOS** (`Info.plist`) :
```xml
<string>AWS Quiz</string>
```

#### 2. Créer le logo

- Logo AWS (couleur orange)
- 512x512 pixels
- Fond transparent

#### 3. Générer les icons

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app

# Ajouter flutter_launcher_icons à pubspec.yaml
# Puis :
~/flutter/bin/flutter pub run flutter_launcher_icons
```

#### 4. Changer le package name

**`android/app/build.gradle`** :
```gradle
applicationId = "com.example.aws_quiz"
namespace = "com.example.aws_quiz"
```

#### 5. Nettoyer et tester

```bash
~/flutter/bin/flutter clean
~/flutter/bin/flutter run
```

#### 6. Vérifier

- ✅ Nom "AWS Quiz" s'affiche
- ✅ Logo orange visible à l'écran d'accueil
- ✅ Pas d'erreur au lancement

---

## 📚 Outils recommandés

| Outil | Usage | Gratuit ? |
|-------|-------|----------|
| [Figma](https://figma.com) | Créer des logos | ✅ Gratuit (limité) |
| [GIMP](https://gimp.org) | Éditer des images | ✅ Entièrement gratuit |
| [Canva](https://canva.com) | Templates rapides | ✅ Gratuit + Premium |
| [App Icon Generator](https://appicon.co) | Générer icons | ✅ Entièrement gratuit |
| [ImageMagick](https://imagemagick.org) | CLI image processing | ✅ Entièrement gratuit |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | Générer via Flutter | ✅ Package gratuit |

---

**✅ Vous êtes maintenant prêt à personnaliser votre app !** 🎉
