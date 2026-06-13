#!/bin/bash
###############################################################################
# 00_check_requirements.sh
#
# Comprueba que el sistema cumple los requisitos básicos del proyecto ARSandbox:
#   - Sistema operativo: Linux Mint 19.3 / Ubuntu 18.04 (recomendado)
#   - Presencia de una gráfica Nvidia
#   - Paquetes básicos de compilación instalados
#
# Este script es informativo: NO instala nada, solo avisa si algo no coincide
# con las especificaciones recomendadas en el README.
###############################################################################

set -e

echo "Comprobando requisitos del sistema..."
echo ""

# --- Sistema operativo -------------------------------------------------------
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Sistema operativo detectado: $PRETTY_NAME"
    case "$VERSION_ID" in
        18.04|19.1|19.2|19.3)
            echo "  -> Versión recomendada/compatible."
            ;;
        *)
            echo "  -> AVISO: Este proyecto está pensado para Linux Mint 19.3 / Ubuntu 18.04."
            echo "     Versiones más recientes pueden dar problemas con repositorios obsoletos"
            echo "     necesarios para Vrui y el Kinect 3D Video Package."
            ;;
    esac
else
    echo "  -> No se ha podido determinar el sistema operativo (/etc/os-release no encontrado)."
fi

echo ""

# --- Gráfica Nvidia ------------------------------------------------------------
echo "Comprobando gráfica Nvidia..."
if command -v lspci >/dev/null 2>&1; then
    GPU_INFO=$(lspci | grep -i nvidia || true)
    if [ -n "$GPU_INFO" ]; then
        echo "  Gráfica Nvidia detectada:"
        echo "$GPU_INFO" | sed 's/^/    /'
        echo "  -> Series compatibles recomendadas: 16xxx, 20xxx, 30xxx"
        echo "     Driver recomendado: 440 (serie 1650) o 530 (serie 3050)"
    else
        echo "  -> AVISO: No se ha detectado ninguna gráfica Nvidia."
        echo "     El ARSandbox funcionará, pero la simulación de lluvia"
        echo "     requiere una gráfica Nvidia compatible con drivers adecuados."
    fi
else
    echo "  -> 'lspci' no está disponible; no se puede comprobar la gráfica automáticamente."
fi

echo ""

# --- Paquetes básicos de compilación -------------------------------------------
echo "Comprobando paquetes básicos de compilación (build-essential, git, wget)..."
MISSING_PKGS=""
for pkg in build-essential git wget; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        MISSING_PKGS="$MISSING_PKGS $pkg"
    fi
done

if [ -n "$MISSING_PKGS" ]; then
    echo "  -> Faltan los siguientes paquetes:$MISSING_PKGS"
    read -p "     ¿Instalarlos ahora con apt? [s/N]: " resp
    case "$resp" in
        [sS]|[sS][iI])
            sudo apt update
            sudo apt install -y $MISSING_PKGS
            ;;
        *)
            echo "     Instalación de paquetes omitida."
            ;;
    esac
else
    echo "  -> Todos los paquetes básicos están instalados."
fi

echo ""

# --- Carpeta de trabajo ~/src ---------------------------------------------------
if [ ! -d "$HOME/src" ]; then
    echo "Creando carpeta de trabajo $HOME/src ..."
    mkdir -p "$HOME/src"
else
    echo "La carpeta de trabajo $HOME/src ya existe."
fi

echo ""
echo "Comprobación de requisitos finalizada."
