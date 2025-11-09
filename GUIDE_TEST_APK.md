# 🧪 Guide Complet : Tester et Générer l'APK

Guide étape par étape pour tester l'application Quiz et générer l'APK Android.

---

## 📋 Table des matières

1. [Préalables](#-préalables)
2. [Tester sur Linux Desktop](#-tester-sur-linux-desktop)
3. [Tester sur Émulateur Android](#-tester-sur-émulateur-android)
4. [Tester sur Appareil Physique](#-tester-sur-appareil-physique)
5. [Générer l'APK](#-générer-lapk)
6. [Générer l'AAB (Google Play)](#-générer-laab-google-play)
7. [Dépannage](#-dépannage)

---

## ✅ Préalables

Avant de commencer, assurez-vous que :

### 1. Flutter est installé
```bash
~/flutter/bin/flutter --version
```

**Résultat attendu** :
```
Flutter 3.x.x • channel stable
```

### 2. Dépendances installées
```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter pub get
```

### 3. Android SDK configuré (pour APK)
```bash
~/flutter/bin/flutter doctor
```

**Vérifiez que** :
- ✅ Flutter est reconnu
- ✅ Android SDK est installé
- ✅ Android licenses acceptées

Si les licenses ne sont pas acceptées :
```bash
~/Android/Sdk/tools/bin/sdkmanager --licenses
# Répondre 'y' à toutes les questions
```

---

## 🖥️ Tester sur Linux Desktop

### Option 1 : Lancer l'app en debug

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d linux
```

**Résultat** :
- L'application se lance dans une fenêtre Linux
- Hot reload activé (modifications instantanées)
- Parfait pour le développement rapide

### Option 2 : Lancer en mode release (performance optimale)

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d linux --release
```

**Résultat** :
- Application plus rapide et fluide
- Pas de hot reload
- Comportement identique à l'APK final

### Option 3 : Lancer avec verbosité (debug avancé)

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d linux -v
```

**Résultat** :
- Affiche tous les logs détaillés
- Utile pour identifier des erreurs

---

## 📱 Tester sur Émulateur Android

### Étape 1 : Lancer Android Studio (ou l'AVD Manager)

```bash
# Si vous avez Android Studio
~/Android/Sdk/emulator/emulator -list-avds  # Affiche les appareils disponibles
~/Android/Sdk/emulator/emulator -avd nom_dispositif &  # Lance un émulateur
```

**Alternative** : Ouvrir Android Studio → AVD Manager → Lancer un appareil

### Étape 2 : Vérifier que l'émulateur est reconnu

```bash
~/flutter/bin/flutter devices
```

**Résultat attendu** :
```
1 connected device.

Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 12 (API 31)
```

### Étape 3 : Installer l'application sur l'émulateur

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d emulator-5554
```

Ou simplement :
```bash
~/flutter/bin/flutter run  # Flutter choisira automatiquement l'émulateur
```

### Étape 4 : Tester les fonctionnalités

Checklist de test :
- [ ] L'app se lance sans crasher
- [ ] Onglet Quiz : affiche les catégories
- [ ] Onglet Flashcards : affiche les cartes
- [ ] Onglet Progression : affiche les statistiques
- [ ] Répondre à une question et voir le score
- [ ] Marquer une question
- [ ] Voir la question marquée dans "Quick Revision"
- [ ] Swiper les flashcards

---

## 📲 Tester sur Appareil Physique

### Prérequis

1. **Connecter le téléphone** en USB
2. **Activer le mode développeur** :
   - Allez dans Paramètres → À propos du téléphone
   - Appuyez 7 fois sur "Numéro de build"
   - Retournez à Paramètres → Options pour développeurs
   - Activez "Débogage USB"

3. **Autoriser l'appareil** : Accepter l'invite de confiance USB sur le téléphone

### Vérifier la connexion

```bash
~/flutter/bin/flutter devices
```

**Résultat attendu** :
```
1 connected device.

SM-G9700 (mobile) • 192168100132 • android-arm64 • Android 12
```

### Installer et tester

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d <device_id>
```

Exemple :
```bash
~/flutter/bin/flutter run -d SM-G9700
```

### Tester avec capture d'écran en direct

```bash
~/flutter/bin/flutter screenshot
```

**Résultat** : Un fichier `flutter_01.png` est créé avec une capture d'écran

---

## 📦 Générer l'APK

### ⚠️ Avant de générer

1. **Vérifiez la version** dans `pubspec.yaml` :
```yaml
version: 1.0.0+1
#        ↑version  ↑build number
```

2. **Vérifiez le package name** dans `android/app/build.gradle` :
```gradle
android {
    namespace "com.example.quiz_app"  # ← À adapter si besoin
}
```

### Étape 1 : Nettoyer les builds précédents

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter clean
```

### Étape 2 : Récupérer les dépendances

```bash
~/flutter/bin/flutter pub get
```

### Étape 3 : Générer l'APK en debug (test)

Pour tester rapidement :
```bash
~/flutter/bin/flutter build apk --debug
```

**Résultat** :
```
✓ Built build/app/outputs/flutter-apk/app-debug.apk
```

**Localisation** : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/build/app/outputs/flutter-apk/app-debug.apk`

### Étape 4 : Générer l'APK en release (production)

Pour une version de qualité production :
```bash
~/flutter/bin/flutter build apk --release
```

**Résultat** :
```
✓ Built build/app/outputs/flutter-apk/app-release.apk
```

**Localisation** : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/build/app/outputs/flutter-apk/app-release.apk`

### Étape 5 : Tester l'APK sur un appareil

Transférez l'APK :
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

Ou via le fichier manager :
1. Connectez votre téléphone
2. Transférez `app-release.apk`
3. Installez le fichier depuis le gestionnaire de fichiers

---

## 🚀 Générer l'AAB (Google Play)

### Pourquoi l'AAB ?

- **APK** : Un seul fichier pour tous les téléphones
- **AAB** : Google Play génère des APK optimisés pour chaque appareil
- ✅ Plus petit, meilleure performance, recommandé par Google

### Étape 1 : Créer une clé de signature

Si vous n'en avez pas encore :
```bash
keytool -genkey -v -keystore ~/quiz_app_key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias quiz_app_key
```

Vous serez demandé :
- Mot de passe de la clé (`password123` par exemple)
- Informations personnelles (nom, ville, etc.)

⚠️ **Gardez cette clé en sécurité !** Vous en aurez besoin pour les mises à jour

### Étape 2 : Configurer la signature dans Flutter

Créez/modifiez `android/key.properties` :
```properties
storePassword=password123
keyPassword=password123
keyAlias=quiz_app_key
storeFile=/home/vrm/quiz_app_key.jks
```

### Étape 3 : Générer l'AAB

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter build appbundle --release
```

**Résultat** :
```
✓ Built build/app/outputs/bundle/release/app-release.aab
```

**Localisation** : `~/mobile-quiz-app/mobile-quiz-app/quiz_app/build/app/outputs/bundle/release/app-release.aab`

### Étape 4 : Uploader sur Google Play Console

1. Allez sur https://play.google.com/console
2. Créez une nouvelle application
3. Allez à "Release" → "Production"
4. Cliquez "Créer une version"
5. Uploadez `app-release.aab`
6. Remplissez les informations requises
7. Soumettez pour révision

---

## 📊 Optimisations de Build

### Réduire la taille de l'APK

```bash
# Activer shrinking et obfuscation
~/flutter/bin/flutter build apk --release --split-per-abi
```

**Résultat** : Trois APK séparés (arm64-v8a, armeabi-v7a, x86_64)

### Build avec target spécifique

```bash
# Seulement pour ARM64 (98% des appareils modernes)
~/flutter/bin/flutter build apk --release --target-platform android-arm64
```

---

## 🔍 Dépannage

### Erreur : "Android SDK not found"

```bash
# Définir le chemin vers Android SDK
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin
```

Ou mettre dans `~/.bashrc` :
```bash
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin
```

### Erreur : "No connected devices"

```bash
# Redémarrer le daemon ADB
adb kill-server
adb start-server
adb devices
```

### Erreur : "Permission denied" lors de la génération

```bash
# Donner les permissions
chmod +x ~/Android/Sdk/tools/bin/*
chmod +x ~/flutter/bin/flutter
```

### L'APK se ferme au lancement

1. Vérifiez les logs :
```bash
adb logcat | grep -i flutter
```

2. Relancez depuis le terminal :
```bash
adb shell am force-stop com.example.quiz_app
adb shell am start -n com.example.quiz_app/.MainActivity
adb logcat
```

### Le hotreload ne marche pas

```bash
# Relancer l'app
r  # Hot reload
R  # Full restart (plus lent)
q  # Quitter
```

---

## 📝 Checklist de Build Final

Avant de soumettre sur Google Play :

- [ ] Version mise à jour dans `pubspec.yaml` (ex: 1.0.1+2)
- [ ] Tous les tests passent : `~/flutter/bin/flutter test`
- [ ] App testée en release sur un vrai appareil
- [ ] Icons et splashscreen corrects
- [ ] Pas de logs d'erreur dans la console
- [ ] Catégories et questions chargées correctement
- [ ] Quiz fonctionne sans crash
- [ ] Flashcards s'affichent correctement
- [ ] Statistiques enregistrées
- [ ] Marquages persistants après redémarrage
- [ ] Performance acceptable (pas de freezes)

---

## 🔄 Workflow Complet de Développement

### Développement rapide (Linux)

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app

# Terminal 1 : Lancer l'app
~/flutter/bin/flutter run -d linux

# Terminal 2 : Éditer le code (hot reload automatique)
# Modifier un fichier → Appuyer sur 'r' dans le terminal 1
```

### Test sur Émulateur

```bash
# Terminal 1 : Lancer l'émulateur
~/Android/Sdk/emulator/emulator -avd pixel_5 &

# Terminal 2 : Lancer l'app
~/flutter/bin/flutter run
```

### Validation avant commit

```bash
# Analyser le code
~/flutter/bin/flutter analyze

# Formater le code
~/flutter/bin/flutter format .

# Lancer les tests
~/flutter/bin/flutter test

# Nettoyer les builds
~/flutter/bin/flutter clean
```

### Générer et tester l'APK final

```bash
# Nettoyer
~/flutter/bin/flutter clean

# Récupérer les dépendances
~/flutter/bin/flutter pub get

# Générer l'APK release
~/flutter/bin/flutter build apk --release

# Tester sur appareil
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 📞 Commandes Utiles

| Commande | Description |
|----------|-------------|
| `flutter devices` | Liste les appareils connectés |
| `flutter run -d <id>` | Lance l'app sur un appareil spécifique |
| `flutter run --release` | Lance en mode release (performance) |
| `flutter build apk --release` | Génère l'APK release |
| `flutter build appbundle --release` | Génère l'AAB pour Google Play |
| `flutter doctor` | Vérifie l'installation Flutter |
| `flutter pub get` | Télécharge les dépendances |
| `flutter clean` | Nettoie les builds précédents |
| `flutter analyze` | Analyse le code pour erreurs/avertissements |
| `flutter format .` | Formate le code selon les conventions |
| `flutter test` | Lancer les tests unitaires |
| `adb devices` | Liste les appareils Android |
| `adb logcat` | Affiche les logs Android en temps réel |
| `adb shell` | Accède au shell de l'appareil |

---

## 📚 Ressources

- **Flutter Docs** : https://flutter.dev/docs
- **Android Studio** : https://developer.android.com/studio
- **Google Play Console** : https://play.google.com/console
- **Flutter Build Guide** : https://flutter.dev/docs/deployment/android
- **APK vs AAB** : https://developer.android.com/guide/app-bundle

---

**✅ Vous êtes prêt à tester et déployer votre application !** 🚀
