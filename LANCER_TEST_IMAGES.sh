#!/bin/bash

echo "🚀 Lancement du test des images..."
echo ""

# Navigation
cd /home/vrm/mobile-quiz-app/mobile-quiz-app/quiz_app

# Vérifier les fichiers
echo "📋 Vérification des fichiers..."
echo ""

if [ -f "assets/data/Réseaux/questions.yaml" ]; then
    echo "✅ Fichier questions.yaml trouvé"
    if grep -q "net_q_img_001" assets/data/Réseaux/questions.yaml; then
        echo "✅ Question avec images trouvée (net_q_img_001)"
    else
        echo "❌ Question avec images NOT trouvée"
    fi
else
    echo "❌ Fichier questions.yaml NOT trouvé"
fi

echo ""

if [ -f "assets/images/Réseaux/network_bus.png" ]; then
    echo "✅ Image network_bus.png trouvée"
else
    echo "❌ Image network_bus.png NOT trouvée"
fi

if [ -f "assets/images/Réseaux/network_star.png" ]; then
    echo "✅ Image network_star.png trouvée"
else
    echo "❌ Image network_star.png NOT trouvée"
fi

echo ""
echo "🔨 Compilation de l'app..."
echo ""

# Build
flutter build linux

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build réussi!"
    echo ""
    echo "🎬 Lancement de l'app..."
    echo ""
    echo "Instructions de test:"
    echo "1. Attendre que l'app se lance"
    echo "2. Cliquer sur 'Réseaux' dans les catégories"
    echo "3. Chercher la question '🖼️ TEST IMAGES'"
    echo "4. Cliquer sur les images pour zoomer"
    echo "5. Double-clic pour zoom 3x"
    echo "6. Pincer pour zoom/dézoom"
    echo ""
    
    flutter run -d linux
else
    echo "❌ Build échoué!"
    exit 1
fi
