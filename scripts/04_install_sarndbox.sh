#!/bin/bash
###############################################################################
# 04_install_sarndbox.sh
#
# Descarga y compila Augmented Reality Sandbox (SARndbox), versión 2.8.
#
# Página de descarga oficial:
#   https://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/Download.html
#
# Tras la compilación, comprueba que aparecen los binarios CalibrateProjector,
# SARndbox y SARndboxClient en ./bin.
###############################################################################

set -e

echo "Instalación de Augmented Reality Sandbox 2.8"
echo "-----------------------------------------------"

mkdir -p "$HOME/src"
cd "$HOME/src"

echo "Descargando SARndbox-2.8.tar.gz..."
wget -nc http://web.cs.ucdavis.edu/~okreylos/ResDev/SARndbox/SARndbox-2.8.tar.gz

echo "Descomprimiendo..."
tar xfz SARndbox-2.8.tar.gz

cd SARndbox-2.8

echo ""
echo "Compilando SARndbox (puede tardar)..."
make

echo ""
echo "Comprobando los binarios generados..."
ls ./bin

echo ""
echo "Deberían aparecer 'CalibrateProjector', 'SARndbox' y 'SARndboxClient'"
echo "en la lista anterior."
echo ""
echo "Instalación/compilación de SARndbox finalizada."
echo ""
echo "Siguiente paso recomendado: calibración de la Kinect y del proyector."
echo "Consulta el README.md (sección 'Calibración') o ejecuta:"
echo "  ./scripts/06_calibration.sh"
