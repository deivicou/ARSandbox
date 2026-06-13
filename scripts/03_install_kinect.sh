#!/bin/bash
###############################################################################
# 03_install_kinect.sh
#
# Descarga, compila e instala el Kinect 3D Video Package, versión 3.10.
#
# Página de descarga oficial:
#   https://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/Download.html
#
# Tras la instalación, comprueba que aparecen los binarios KinectUtil y
# RawKinectViewer en /usr/local/bin.
#
# Si tu Kinect es el modelo 1473 o superior, este script instala además
# las reglas udev específicas para ese modelo. Si usas el modelo 1414
# (como en el montaje original), esto no es necesario.
###############################################################################

set -e

echo "Instalación del Kinect 3D Video Package 3.10"
echo "-----------------------------------------------"

mkdir -p "$HOME/src"
cd "$HOME/src"

echo "Descargando Kinect-3.10.tar.gz..."
wget -nc http://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/Kinect-3.10.tar.gz

echo "Descomprimiendo..."
tar xfz Kinect-3.10.tar.gz

cd Kinect-3.10

echo ""
echo "Compilando Kinect 3D Video Package (puede tardar)..."
make

echo ""
echo "Instalando..."
sudo make install
sudo make installudevrules

echo ""
echo "Comprobando que los binarios se han instalado correctamente..."
ls /usr/local/bin | grep -iE "Kinect" || true
echo ""
echo "Deberían aparecer 'KinectUtil' y 'RawKinectViewer' en la lista anterior."

echo ""
echo "------------------------------------------------------------------"
echo "Modelo de Kinect"
echo "------------------------------------------------------------------"
echo "El proyecto original utiliza el modelo Kinect 1414."
echo "Si tu Kinect es el modelo 1473 o superior, es necesario instalar"
echo "reglas udev adicionales."
echo ""

read -p "¿Tu Kinect es el modelo 1473 o superior? [s/N]: " resp
case "$resp" in
    [sS]|[sS][iI])
        echo "Instalando reglas udev para Kinect 1473+..."
        sudo wget -O /etc/udev/rules.d/70-Kinect.rules \
            https://web.cs.ucdavis.edu/~okreylos/ResDev/Kinect/70-Kinect.rules
        sudo udevadm control --reload
        sudo udevadm trigger --action=change
        ;;
    *)
        echo "No se instalan reglas udev adicionales (modelo 1414 o no especificado)."
        ;;
esac

echo ""
echo "Instalación del Kinect 3D Video Package finalizada."
