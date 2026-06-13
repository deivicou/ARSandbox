#!/bin/bash
###############################################################################
# 05_setup_shortcuts.sh
#
# Crea:
#   - El fichero de configuración de la aplicación
#     (~/.config/Vrui-8.0/Applications/SARndbox.cfg)
#   - El script de arranque ~/src/SARndbox-2.8/RunSARndbox.sh
#   - El icono de escritorio ~/Escritorio/RunSARndbox.desktop
#     (o ~/Desktop si esa carpeta es la que existe en el sistema)
#
# Los ficheros de configuración de referencia se encuentran en la carpeta
# 'config/' de este repositorio y se copian/adaptan a las rutas del usuario
# actual.
###############################################################################

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SARNDBOX_DIR="$HOME/src/SARndbox-2.8"

echo "Configuración de accesos directos para ARSandbox"
echo "----------------------------------------------------"

# --- 1. Fichero de configuración SARndbox.cfg ---------------------------------
CONFIG_DIR="$HOME/.config/Vrui-8.0/Applications"
mkdir -p "$CONFIG_DIR"

if [ -f "$REPO_DIR/config/SARndbox.cfg" ]; then
    echo "Copiando config/SARndbox.cfg a $CONFIG_DIR/SARndbox.cfg"
    cp "$REPO_DIR/config/SARndbox.cfg" "$CONFIG_DIR/SARndbox.cfg"
else
    echo "AVISO: no se ha encontrado $REPO_DIR/config/SARndbox.cfg"
    echo "       Revisa la sección 'Configuración' del README.md para crearlo manualmente."
fi

# --- 2. Script de arranque RunSARndbox.sh --------------------------------------
if [ -d "$SARNDBOX_DIR" ]; then
    echo "Creando $SARNDBOX_DIR/RunSARndbox.sh"
    cat > "$SARNDBOX_DIR/RunSARndbox.sh" << 'EOF'
#!/bin/bash
# Entra en el directorio de SARndbox
cd ~/src/SARndbox-2.8
# Ejecuta SARndbox con los parámetros adecuados:
#   -uhm : añade el mapa de color (height map)
#   -fpv : usa la calibración adicional del proyector
./bin/SARndbox -uhm -fpv
EOF
    chmod a+x "$SARNDBOX_DIR/RunSARndbox.sh"
else
    echo "AVISO: no existe $SARNDBOX_DIR."
    echo "       Asegúrate de haber ejecutado primero 04_install_sarndbox.sh."
fi

# --- 3. Icono de escritorio -----------------------------------------------------
if [ -d "$HOME/Escritorio" ]; then
    DESKTOP_DIR="$HOME/Escritorio"
elif [ -d "$HOME/Desktop" ]; then
    DESKTOP_DIR="$HOME/Desktop"
else
    DESKTOP_DIR="$HOME/Escritorio"
    mkdir -p "$DESKTOP_DIR"
fi

DESKTOP_FILE="$DESKTOP_DIR/RunSARndbox.desktop"

echo "Creando icono de escritorio en $DESKTOP_FILE"
cat > "$DESKTOP_FILE" << EOF
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon=mate-panel-launcher
Name=Start the AR Sandbox
Comment=Inicia la aplicacion ARSandbox
Exec=$SARNDBOX_DIR/RunSARndbox.sh
EOF

chmod a+x "$DESKTOP_FILE"

echo ""
echo "Accesos directos creados correctamente:"
echo "  - Configuración: $CONFIG_DIR/SARndbox.cfg"
echo "  - Script de arranque: $SARNDBOX_DIR/RunSARndbox.sh"
echo "  - Icono de escritorio: $DESKTOP_FILE"
echo ""
echo "Recuerda revisar y ajustar, si es necesario:"
echo "  - El nivel de agua en ~/src/SARndbox-2.8/BoxLayout.txt"
echo "  - Los parámetros de lluvia en $CONFIG_DIR/SARndbox.cfg"
