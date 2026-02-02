#!/bin/bash

echo "🚀 Création de l'installeur DoomscrollTracker..."

# Build l'app
echo "📦 Build de l'application..."
pyinstaller build_app.spec --noconfirm

# Crée le DMG
echo "💿 Création du DMG..."
rm -f DoomscrollTracker.dmg

# Crée un dossier temporaire pour le DMG
mkdir -p dmg_temp
cp -R dist/DoomscrollTracker.app dmg_temp/
ln -s /Applications dmg_temp/Applications

# Crée le DMG
hdiutil create -volname "DoomscrollTracker" -srcfolder dmg_temp -ov -format UDZO DoomscrollTracker.dmg

# Nettoie
rm -rf dmg_temp

echo "✅ DMG créé : DoomscrollTracker.dmg"
echo "📤 Prêt à distribuer !"