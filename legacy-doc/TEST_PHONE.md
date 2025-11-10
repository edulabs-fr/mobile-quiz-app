# 📱 Guide : Tester l'App sur Votre Téléphone

Guide rapide pour installer et tester l'application Quiz sur votre téléphone Android.

---

## 📋 Prérequis

### Sur votre téléphone
1. **Mode développeur activé**
   - Allez dans **Paramètres** → **À propos du téléphone**
   - Appuyez **7 fois** sur "Numéro de build"
   - Allez dans **Paramètres** → **Options pour développeurs**
   - Activez **"Débogage USB"**

2. **Câble USB** pour connecter le téléphone

### Sur votre ordinateur
- Flutter installé ✅ (vous l'avez)
- ADB (Android Debug Bridge) - vient avec Android SDK ✅

---

## 🔌 Étape 1 : Connecter votre téléphone

### 1. Brancher le téléphone en USB

Connectez votre téléphone à l'ordinateur avec le câble USB.

### 2. Accepter le débogage USB

Un message s'affiche sur votre téléphone :
```
Autoriser le débogage USB sur cet ordinateur ?
```

Appuyez sur **"Autoriser"** ✅

### 3. Vérifier la connexion

Ouvrez un terminal et tapez :

```bash
adb devices
```

**Résultat attendu** :
```
List of attached devices
SM-G9700                    device
```

Si vous voyez `device` (pas `offline`), la connexion est bonne ! ✅

---

## 🚀 Étape 2 : Générer l'APK pour téléphone

### Option A : Installation directe (plus rapide)

Lancer directement l'app sur le téléphone :

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run -d <device_id>
```

**Exemple** :
```bash
~/flutter/bin/flutter run -d SM-G9700
```

Ou simplement (Flutter choisira automatiquement) :
```bash
~/flutter/bin/flutter run
```

### Option B : Générer un APK à tester

Si vous préférez un fichier APK :

```bash
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter build apk --debug
```

**Localisation du fichier** :
```
~/mobile-quiz-app/mobile-quiz-app/quiz_app/build/app/outputs/flutter-apk/app-debug.apk
```

Puis installer sur le téléphone :
```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

---

## 🧪 Étape 3 : Tester l'application

### Checklist de test

Une fois l'app lancée sur votre téléphone, testez :

- [ ] L'app se lance sans crasher
- [ ] Le nom de l'app s'affiche correctement
- [ ] Les questions s'affichent avec la bonne taille de police (petite)
- [ ] Les options de réponse sont compactes
- [ ] Vous pouvez sélectionner une catégorie
- [ ] Vous pouvez choisir le nombre de questions
- [ ] Le quiz démarre correctement
- [ ] Les réponses se valident
- [ ] Les explications s'affichent
- [ ] Vous pouvez marquer une question
- [ ] Vous pouvez naviguer vers la question suivante
- [ ] L'écran de progression s'affiche à la fin
- [ ] L'onglet Flashcards fonctionne
- [ ] L'onglet Progression affiche les statistiques
- [ ] L'app répond bien aux touches

---

## 📊 Commandes utiles

| Commande | Description |
|----------|-------------|
| `adb devices` | Liste les téléphones connectés |
| `adb shell` | Accéder au terminal du téléphone |
| `adb logcat` | Afficher les logs en temps réel |
| `adb install file.apk` | Installer un APK |
| `adb uninstall com.edulabs.quiz_app` | Désinstaller l'app |
| `adb shell am force-stop com.edulabs.quiz_app` | Forcer l'arrêt |

---

## 🐛 Dépannage

### Le téléphone ne s'affiche pas
```bash
# Redémarrer le service ADB
adb kill-server
adb start-server
adb devices
```

### L'app crash au lancement
```bash
# Voir les logs d'erreur
adb logcat | grep -i flutter
```

### Personne n'a trouvé de dispositif
```bash
# Accepter à nouveau le débogage USB sur le téléphone
# Puis :
adb kill-server
adb start-server
adb devices
```

---

## ✅ Résumé rapide

```bash
# 1. Connecter le téléphone et accepter le débogage
# 2. Vérifier la connexion
adb devices

# 3. Lancer l'app sur le téléphone
cd ~/mobile-quiz-app/mobile-quiz-app/quiz_app
~/flutter/bin/flutter run

# 4. Attendre le lancement (30-60 secondes)
# 5. Tester l'application !
```

**Besoin d'aide ?** Utilisez `adb logcat` pour voir les erreurs en détail.

---

**Bonne chance pour le test ! 🚀📱**
