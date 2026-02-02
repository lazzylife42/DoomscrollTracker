.PHONY: install build dmg clean run test

# Variables
APP_NAME = DoomscrollTracker
VENV = venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip

# Installation des dépendances
install:
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install ultralytics opencv-python pyinstaller "numpy<2"
	@echo "✅ Dépendances installées"

# Convertit l'icône
icon:
	@if [ -f image.jpg ]; then \
		sips -s format png image.jpg --out image.png; \
		rm -rf icon.iconset icon.icns; \
		mkdir icon.iconset; \
		sips -z 16 16 image.png --out icon.iconset/icon_16x16.png; \
		sips -z 32 32 image.png --out icon.iconset/icon_16x16@2x.png; \
		sips -z 32 32 image.png --out icon.iconset/icon_32x32.png; \
		sips -z 64 64 image.png --out icon.iconset/icon_32x32@2x.png; \
		sips -z 128 128 image.png --out icon.iconset/icon_128x128.png; \
		sips -z 256 256 image.png --out icon.iconset/icon_128x128@2x.png; \
		sips -z 256 256 image.png --out icon.iconset/icon_256x256.png; \
		sips -z 512 512 image.png --out icon.iconset/icon_256x256@2x.png; \
		sips -z 512 512 image.png --out icon.iconset/icon_512x512.png; \
		sips -z 1024 1024 image.png --out icon.iconset/icon_512x512@2x.png; \
		iconutil -c icns icon.iconset; \
		rm -rf icon.iconset; \
		echo "✅ Icône créée"; \
	else \
		echo "⚠️  image.jpg non trouvé, skip icône"; \
	fi

# Build l'application
build: icon
	$(VENV)/bin/pyinstaller build_app.spec --noconfirm
	@echo "✅ App buildée dans dist/$(APP_NAME).app"

# Crée le DMG pour distribution
dmg: build
	@echo "💿 Création du DMG..."
	@rm -f $(APP_NAME).dmg
	@mkdir -p dmg_temp
	@cp -R dist/$(APP_NAME).app dmg_temp/
	@ln -s /Applications dmg_temp/Applications
	@hdiutil create -volname "$(APP_NAME)" -srcfolder dmg_temp -ov -format UDZO $(APP_NAME).dmg
	@rm -rf dmg_temp
	@echo "✅ DMG créé : $(APP_NAME).dmg"

# Lance l'app en dev
run:
	$(PYTHON) main.py

# Test de l'app buildée
test: build
	dist/$(APP_NAME).app/Contents/MacOS/$(APP_NAME)

# Nettoie les fichiers générés
clean:
	rm -rf build dist *.spec __pycache__
	rm -rf icon.iconset icon.icns image.png
	rm -f $(APP_NAME).dmg
	@echo "✅ Nettoyé"

# Nettoie tout (y compris venv)
clean-all: clean
	rm -rf $(VENV)
	@echo "✅ Tout nettoyé"

# Help
help:
	@echo "Makefile DoomscrollTracker"
	@echo ""
	@echo "Commandes disponibles:"
	@echo "  make install    - Installe les dépendances"
	@echo "  make icon       - Crée l'icône depuis image.jpg"
	@echo "  make build      - Build l'application"
	@echo "  make dmg        - Crée l'installeur DMG"
	@echo "  make run        - Lance en mode dev"
	@echo "  make test       - Teste l'app buildée"
	@echo "  make clean      - Nettoie les fichiers générés"
	@echo "  make clean-all  - Nettoie tout (y compris venv)"