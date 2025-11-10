# 🔨 BUILD GUIDE - Compilation pour toutes plateformes

**Guide complet: Build Linux, Windows, Android APK, Device USB**

---

## 📋 Table des matières

1. [Build Linux](#-build-linux)
2. [Build Windows](#-build-windows)
3. [Build Android APK](#-build-android-apk)
4. [Build sur Device Android (USB)](#-build-sur-device-android-usb)
5. [Troubleshooting](#-troubleshooting)
6. [Comparaison rapide](#-comparaison-rapide)

---

## 🐧 Build Linux

### Prérequis

```bash
# Installer dépendances Linux (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y \
  clang \
  cmake \
  git \
  gtk-3-dev \
  libgtk-3-dev \
  ninja-build \
  pkg-config \
  xorg-dev
```

### Build de développement (avec hot-reload)

```bash
# Aller dans le dossier projet
cd mobile-quiz-app

# Télécharger dépendances
flutter pub get

# Lancer en développement (Linux desktop)
flutter run -d linux
```

**Résultat:** App lancée avec hot-reload activé
- Appuyer `r` → Hot reload (changements immédiat)
- Appuyer `R` → Hot restart (restart app)
- Appuyer `q` → Quitter

### Build de production (Release)

```bash
# Nettoyer cache
flutter clean

# Télécharger dépendances
flutter pub get

# Build Linux release
flutter build linux --release
```

**Résultat:** 
```
build/linux/x64/release/bundle/quiz_app
```

**Lancer le binary:**
```bash
./build/linux/x64/release/bundle/quiz_app
```

### Debug avec logs

```bash
# Lancer avec mode verbose (tous les logs)
flutter run -d linux --verbose

# Filtrer logs spécifiques
flutter run -d linux 2>&1 | grep -i "error\|warning"
```

---

## 🪟 Build Windows

### Prérequis

```
✅ Windows 10/11 64-bit
✅ Visual Studio 2022 (Community OK)
✅ Windows SDK (C++ development)
✅ Flutter SDK
✅ Git
```

**Installation Visual Studio C++:**
1. Télécharger Visual Studio Community
2. Installer avec "Desktop development with C++"
3. Accepter installation

### Vérifier setup

```bash
# Dans PowerShell ou CMD
flutter doctor

# Output doit montrer:
# [✓] Flutter
# [✓] Windows version
# [✓] Visual Studio
```

### Build de développement (avec hot-reload)

```bash
# Aller dans le dossier projet
cd mobile-quiz-app

# Télécharger dépendances
flutter pub get

# Lancer en développement (Windows desktop)
flutter run -d windows
```

**Résultat:** App lancée avec hot-reload
- Mêmes commandes que Linux (r, R, q)

### Build de production (Release)

```bash
# Nettoyer cache
flutter clean

# Télécharger dépendances
flutter pub get

# Build Windows release
flutter build windows --release
```

**Résultat:**
```
build/windows/x64/runner/Release/quiz_app.exe
```

**Lancer l'exe:**
```bash
.\build\windows\x64\runner\Release\quiz_app.exe
```

### Package pour distribution

```bash
# Créer installateur (optionnel)
flutter build windows --release

# Dossier release prêt pour distribution
build/windows/x64/runner/Release/
```

**À zipper pour partager:**
```bash
# Compresser le dossier
Compress-Archive -Path "build\windows\x64\runner\Release" -DestinationPath "quiz_app_windows.zip"
```

---

## 📱 Build Android APK

### Prérequis

```bash
# Installer Java Development Kit (JDK)
sudo apt-get install openjdk-11-jdk

# Installer Android SDK (via Android Studio recommandé)
# OU utiliser sdkmanager en ligne de commande

# Vérifier installation
flutter doctor
```

### Configuration Android (première fois)

```bash
# Accepter Android licences
flutter doctor --android-licenses

# Répondre 'y' à toutes les questions
```

### Build APK Debug (test rapide)

```bash
# Aller dans le dossier projet
cd mobile-quiz-app

# Télécharger dépendances
flutter pub get

# Générer adapters Hive (si modifié models)
flutter pub run build_runner build

# Build APK debug
flutter build apk --debug
```

**Résultat:**
```
build/app/outputs/apk/debug/app-debug.apk
```

### Build APK Release (production)

```bash
# Nettoyer cache
flutter clean

# Télécharger dépendances
flutter pub get

# Générer adapters Hive
flutter pub run build_runner build

# Build APK release
flutter build apk --release
```

**Résultat:**
```
build/app/outputs/apk/release/app-release.apk
```

### Signer APK (optionnel mais recommandé)

**Créer clé de signature:**
```bash
# Générer keystore (une fois)
keytool -genkey -v \
  -keystore ~/key.jks \
  -keyalgorithm RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias quiz_key

# Questions:
# Keystore password: [créer mot de passe]
# First and last name: Quiz App
# Organizational unit: Development
# Organization: QuizApp
# City: [votre ville]
# State/Province: [votre région]
# Country code: FR
# Confirm: yes
```

**Configurer Flutter pour signer:**

Créer/éditer `android/key.properties`:
```properties
storePassword=[votre_password_keystore]
keyPassword=[votre_password_clé]
keyAlias=quiz_key
storeFile=~/key.jks
```

**Build APK signé:**
```bash
flutter build apk --release

# APK signé automatiquement avec key.properties
```

---

## 📲 Build sur Device Android (USB)

### Prérequis

1. **Device Android branché en USB**
2. **USB debugging activé sur le device**
3. **Drivers Android installés** (auto via Android Studio)

### Activer USB Debugging sur Device

**Android 5-10:**
1. Paramètres → À propos du téléphone
2. Appuyer 7 fois sur "Numéro de build"
3. Paramètres → Options pour développeurs
4. Activer "Débogage USB"
5. Autoriser la connexion USB

**Android 11+:**
1. Paramètres → Système → Options pour développeurs
2. Activer "Débogage USB"

### Vérifier connexion

```bash
# Lister devices connectés
flutter devices

# Résultat attendu:
# 1 connected device:
# Samsung Galaxy S20 (mobile) • ABC123XYZ789 • android-arm64 • Android 11
```

### Build & Run sur Device (Debug)

```bash
# Aller dans le dossier projet
cd mobile-quiz-app

# Télécharger dépendances
flutter pub get

# Générer adapters Hive
flutter pub run build_runner build

# Build & Run sur device connecté
flutter run -d [DEVICE_ID]
```

**Exemple:**
```bash
flutter run -d ABC123XYZ789

# OU sans ID (auto-sélectionne si 1 seul device)
flutter run
```

**Résultat:** App installée et lancée sur device

### Hot-reload sur Device

```bash
# Une fois l'app lancée (flutter run)

# Appuyer 'r' dans terminal → Hot reload
# Appuyer 'R' dans terminal → Hot restart
# Appuyer 'q' dans terminal → Quitter
```

### Build APK + Installer sur Device

```bash
# Build APK release
flutter build apk --release

# Installer sur device connecté
adb install build/app/outputs/apk/release/app-release.apk

# Lancer l'app
adb shell am start -n com.example.mobile_quiz_app/.MainActivity
```

### Déboguer sur Device

```bash
# Voir logs device
flutter run -d [DEVICE_ID] --verbose

# Ou avec adb directement
adb logcat | grep -i "flutter\|error\|exception"
```

---

## 🐛 Troubleshooting

### Erreur: "flutter: command not found"

```bash
# Ajouter Flutter au PATH (Linux/Mac)
export PATH="$PATH:$HOME/flutter/bin"

# Rendre permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Erreur: "No devices found"

```bash
# Vérifier devices connectés
adb devices

# Relancer daemon
adb kill-server
adb start-server

# Vérifier connexion USB device
flutter devices
```

### Erreur: "Android SDK not found"

```bash
# Installer Android SDK
flutter pub global activate fvm  # Optional: use FVM for version management

# Ou accepter Android licences
flutter doctor --android-licenses

# Vérifier
flutter doctor
```

### Erreur: "Gradle build failed"

```bash
# Nettoyer et rebuild
flutter clean
flutter pub get
flutter pub run build_runner build
flutter build apk --release
```

### Erreur: "Unable to build library for architecture"

```bash
# Rebuild avec architecture spécifique
flutter build apk --release --target-platform android-arm64

# Ou pour armv7
flutter build apk --release --target-platform android-arm
```

### Erreur: "JAVA_HOME not set"

```bash
# Vérifier Java
java -version

# Définir JAVA_HOME (Linux)
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
export PATH=$JAVA_HOME/bin:$PATH

# Ou si JDK 11
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

### App crash au démarrage

```bash
# Voir logs
flutter run -d [DEVICE_ID] --verbose 2>&1 | grep -i error

# Ou via adb
adb logcat | grep -i "error\|exception\|flutter"

# Solutions courantes:
# 1. Nettoyer cache: flutter clean
# 2. Rebuild: flutter pub run build_runner build
# 3. Vérifier YAML valide: assets/data/**/*.yaml
```

### Performance lente en debug

```bash
# Build release est beaucoup plus rapide
flutter build apk --release

# Ou run en profile mode
flutter run --profile
```

---

## 📊 Comparaison rapide

| Feature | Linux | Windows | Android (USB) | Android (APK) |
|---------|-------|---------|---------------|---------------|
| **Vitesse build** | ⚡ Rapide | ⚡ Rapide | 🐢 Lent | 🐢 Lent |
| **Hot reload** | ✅ Oui | ✅ Oui | ✅ Oui | ❌ Non |
| **Prérequis** | GTK | Visual Studio | ADB, USB | ADB |
| **Portabilité** | Linux seulement | Windows seulement | Universel | Universel |
| **Cas d'usage** | Dev local | Dev local | Test device | Distribution |
| **Commande** | `flutter run -d linux` | `flutter run -d windows` | `flutter run -d [ID]` | `flutter build apk --release` |
| **Output** | Binary exécutable | .exe | App lancée | .apk (installable) |

---

## 🎯 Workflows courants

### Workflow DEV (Local Linux)

```bash
# 1. Setup (première fois)
cd mobile-quiz-app
flutter pub get
flutter pub run build_runner build

# 2. Chaque session de dev
flutter run -d linux

# 3. Apporter modifications
# [Modifier code]

# 4. Hot reload (rapid testing)
# [Appuyer 'r' dans terminal]

# 5. Fin session
# [Appuyer 'q']
```

### Workflow TEST (Device Android USB)

```bash
# 1. Setup (première fois)
# [Brancher device + activer USB debugging]

# 2. Vérifier connexion
flutter devices

# 3. Chaque session
cd mobile-quiz-app
flutter pub get
flutter pub run build_runner build
flutter run

# 4. Test sur device
# [Utiliser app]

# 5. Voir logs si problème
flutter run --verbose
```

### Workflow RELEASE (APK)

```bash
# 1. Setup (première fois)
# [Créer keystore si besoin]

# 2. Préparation
cd mobile-quiz-app
flutter clean
flutter pub get
flutter pub run build_runner build

# 3. Build APK
flutter build apk --release

# 4. Résultat
# build/app/outputs/apk/release/app-release.apk

# 5. Distribuer APK
# [Email, Drive, Play Store, etc.]
```

---

## 🔍 Vérifier version built

### Android APK

```bash
# Voir info APK
aapt dump badging build/app/outputs/apk/release/app-release.apk | grep -E "package|version"

# Exemple output:
# package: name='com.example.mobile_quiz_app' versionCode='1' versionName='1.0.0'
```

### Linux Binary

```bash
# Voir info (si disponible)
file build/linux/x64/release/bundle/quiz_app

# Exemple output:
# ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked
```

### Windows EXE

```bash
# Propriétés (Windows)
# Right-click → Properties → Details

# Ou PowerShell
(Get-Item "build\windows\x64\runner\Release\quiz_app.exe").VersionInfo
```

---

## 📦 Optimizations

### Build release plus rapide

```bash
# Split APK par architecture (recommandé)
flutter build apk --release --split-per-abi

# Résultat: 3 APKs (arm64, armeabi-v7a, x86_64) plus petits + rapides
# build/app/outputs/apk/release/
#   ├── app-arm64-v8a-release.apk
#   ├── app-armeabi-v7a-release.apk
#   └── app-x86_64-release.apk
```

### Réduire taille APK

```bash
# Activer shrinking dans pubspec.yaml
# Puis build
flutter build apk --release

# Tips supplémentaires:
# 1. Compresser images PNG
# 2. Supprimer assets non-utilisés
# 3. Utiliser --split-per-abi
```

### Build plus rapide (dev)

```bash
# Build debug (plus rapide que release)
flutter build apk --debug

# Build directement sur device (pas fichier intermédiaire)
flutter run

# Profile mode (entre debug et release)
flutter run --profile
```

---

## ✅ Checklist pre-build

- [ ] Code compilé sans erreurs: `flutter analyze`
- [ ] Dépendances à jour: `flutter pub get`
- [ ] Adapters Hive générés: `flutter pub run build_runner build`
- [ ] YAML valide: Pas d'erreurs indentation
- [ ] Images déclarées: `pubspec.yaml` à jour
- [ ] Cache nettoyé: `flutter clean` (si problèmes)
- [ ] Devices visibles: `flutter devices` (pour device build)

---

**Dernière mise à jour:** 2025-11-10

**Pour:** Développeurs et administrateurs système

**Lié à:** [ARCHITECTURE.md](ARCHITECTURE.md) - Déploiement section
