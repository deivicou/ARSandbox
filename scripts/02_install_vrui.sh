#!/bin/bash
###############################################################################
# 02_install_vrui.sh
#
# Descarga y compila Vrui VR Development Toolkit, versión 8.0-002.
#
# Nota: la versión 8.0-001 da problemas al partir del script .sh, por lo que
# se utiliza específicamente la 8.0-002 (que es la que se descarga mediante
# Build-Ubuntu.sh).
#
# Página de descarga oficial:
#   http://web.cs.ucdavis.edu/~okreylos/ResDev/Vrui/Download.html
#
# Tras la instalación, se puede comprobar que todo funciona ejecutando el
# programa de ejemplo ShowEarthModel.
###############################################################################

set -e

echo "Instalación de Vrui VR Development Toolkit 8.0-002"
echo "----------------------------------------------------"

mkdir -p "$HOME/src"
cd "$HOME"

echo "Descargando el script de compilación Build-Ubuntu.sh..."
wget -nc http://web.cs.ucdavis.edu/~okreylos/ResDev/Vrui/Build-Ubuntu.sh

echo ""
echo "Ejecutando Build-Ubuntu.sh (esto compilará Vrui 8.0-002, puede tardar)..."
bash Build-Ubuntu.sh

echo ""
read -p "¿Eliminar el script Build-Ubuntu.sh tras la instalación? [s/N]: " resp
case "$resp" in
    [sS]|[sS][iI])
        rm -f "$HOME/Build-Ubuntu.sh"
        ;;
    *)
        echo "Se conserva $HOME/Build-Ubuntu.sh"
        ;;
esac

echo ""
echo "Instalación de Vrui finalizada."
echo ""
echo "Puedes comprobar que Vrui funciona ejecutando el programa de ejemplo:"
echo "  $HOME/src/Vrui-8.0-002/ExamplePrograms/bin/ShowEarthModel"
echo ""

read -p "¿Ejecutar ShowEarthModel ahora para comprobar la instalación? [s/N]: " resp_test
case "$resp_test" in
    [sS]|[sS][iI])
        if [ -x "$HOME/src/Vrui-8.0-002/ExamplePrograms/bin/ShowEarthModel" ]; then
            "$HOME/src/Vrui-8.0-002/ExamplePrograms/bin/ShowEarthModel" &
        else
            echo "No se ha encontrado el binario ShowEarthModel en la ruta esperada."
            echo "Revisa $HOME/src/Vrui-8.0-002/ExamplePrograms/bin/"
        fi
        ;;
    *)
        echo "Comprobación omitida."
        ;;
esac
