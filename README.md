# DoomscrollTracker 🚨📱

Anti-doomscroll tool qui détecte quand tu regardes ton téléphone et lance une vidéo pour te rappeler d'arrêter.

## Prérequis

- macOS (testé sur macOS 13+)
- Python 3.11
- VLC installé dans `/Applications/VLC.app`
- Webcam

## Installation (Dev)
```bash
# Clone le repo
git clone <repo_url>
cd cloclo_tracker

# Installe les dépendances
make install

# Télécharge le modèle YOLO (si pas inclus)
# Il se télécharge auto au premier lancement

# Place ta vidéo
# Renomme ta vidéo en Indiana_Jones.mp4 ou modifie main.py

# Lance
make run
```

## Build pour distribution
```bash
# Build l'app
make build

# Crée l'installeur DMG
make dmg
```

Le fichier `DoomscrollTracker.dmg` est prêt à être distribué !

## Utilisation

1. Double-clique sur `DoomscrollTracker.app`
2. Autorise l'accès caméra dans les Réglages Système
3. Quand l'app détecte un téléphone → vidéo en fullscreen
4. Range ton téléphone → vidéo se ferme
5. Appuie sur 'Q' pour quitter

## Structure
```
.
├── main.py                 # Code principal
├── build_app.spec          # Config PyInstaller
├── image.jpg               # Icône source
├── Indiana_Jones.mp4       # Vidéo à afficher
├── yolov8n.pt             # Modèle YOLO (auto-téléchargé)
├── Makefile               # Commandes de build
└── README.md              # Ce fichier
```

## Commandes Makefile
```bash
make install    # Installe les dépendances
make icon       # Génère l'icône
make build      # Build l'app
make dmg        # Crée le DMG
make run        # Lance en dev
make test       # Teste l'app buildée
make clean      # Nettoie
```

## Distribution

Pour distribuer à quelqu'un :

1. Build le DMG : `make dmg`
2. Envoie `DoomscrollTracker.dmg`
3. L'utilisateur doit avoir VLC installé

**Note :** L'app n'est pas signée, l'utilisateur devra faire clic-droit > Ouvrir au premier lancement.

## Technos utilisées

- **YOLOv8** (Ultralytics) - Détection d'objets
- **OpenCV** - Traitement vidéo
- **PyInstaller** - Bundle macOS
- **VLC** - Lecture vidéo
