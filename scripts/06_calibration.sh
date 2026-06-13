#!/bin/bash
###############################################################################
# 06_calibration.sh
#
# Ayuda interactiva para la calibración de la Kinect y del proyector.
#
# La calibración es un proceso manual que requiere interactuar físicamente
# con la caja de arena (colocar un CD de referencia, hacer hoyos, mover el
# ratón sobre puntos concretos, etc.), por lo que este script NO la
# automatiza por completo. En su lugar:
#
#   1. Muestra un resumen de los pasos a seguir.
#   2. Lanza las herramientas correspondientes (RawKinectViewer,
#      CalibrateProjector) cuando el usuario confirme.
#
# Consulta la sección "Calibración" del README.md para la explicación
# detallada de cada paso.
###############################################################################

set -e

SARNDBOX_DIR="$HOME/src/SARndbox-2.8"

echo "######################################################################"
echo "# Ayuda de calibración del ARSandbox                                 #"
echo "######################################################################"
echo ""
echo "Este proceso consta de dos partes:"
echo "  A) Calibración de la cámara y el plano de la arena (RawKinectViewer)"
echo "  B) Calibración del proyector (CalibrateProjector)"
echo ""
echo "Antes de empezar, asegúrate de que la Kinect está conectada y de"
echo "haber descargado la calibración de fábrica con:"
echo "  sudo /usr/local/bin/KinectUtil getCalib 0"
echo ""

read -p "¿Ejecutar 'KinectUtil getCalib 0' ahora? [s/N]: " resp
case "$resp" in
    [sS]|[sS][iI])
        sudo /usr/local/bin/KinectUtil getCalib 0
        ;;
    *)
        echo "Paso omitido."
        ;;
esac

echo ""
echo "----------------------------------------------------------------------"
echo "A) Calibración de la cámara y el plano de la arena"
echo "----------------------------------------------------------------------"
echo "Pasos resumidos (ver README.md para el detalle completo):"
echo "  1. Con 'Z' mueve la imagen y haz zoom para ajustarla a la proyección."
echo "  2. Botón derecho > Set Depth Range: ajusta el color de profundidad."
echo "  3. Tecla '1' abre el menú -> selecciona 'Extract Equation'."
echo "  4. Botón derecho > Average Frame: promedia varias imágenes."
echo "  5. Dibuja el rectángulo de la arena manteniendo pulsada la tecla '1'"
echo "     desde la esquina superior izquierda. En el terminal aparecerán"
echo "     dos ecuaciones: la 2ª es la de la cámara (la que interesa)."
echo "  6. Remapea la tecla '2' a 'Measure 3D Position' y toma las 4 esquinas"
echo "     de la caja (inf. izq., inf. der., sup. izq., sup. der.)."
echo "  7. Cierra la aplicación."
echo ""
echo "Tras esto, edita ~/src/SARndbox-2.8/BoxLayout.txt con los valores obtenidos."
echo ""

read -p "¿Lanzar RawKinectViewer ahora? [s/N]: " resp_a
case "$resp_a" in
    [sS]|[sS][iI])
        if [ -d "$SARNDBOX_DIR" ]; then
            cd "$SARNDBOX_DIR"
            RawKinectViewer -compress 0
        else
            echo "No se encuentra $SARNDBOX_DIR. Ejecuta primero 04_install_sarndbox.sh."
        fi
        ;;
    *)
        echo "Paso omitido."
        ;;
esac

echo ""
read -p "¿Editar ahora ~/src/SARndbox-2.8/BoxLayout.txt? [s/N]: " resp_edit
case "$resp_edit" in
    [sS]|[sS][iI])
        ${EDITOR:-xed} "$SARNDBOX_DIR/BoxLayout.txt" &
        ;;
    *)
        echo "Edición omitida."
        ;;
esac

echo ""
echo "----------------------------------------------------------------------"
echo "B) Calibración del proyector"
echo "----------------------------------------------------------------------"
echo "Pasos resumidos (ver README.md para el detalle completo):"
echo "  1. Mapea la tecla '1' a 'Capture' y, tras el menú, asigna la"
echo "     siguiente función a la tecla '2'."
echo "  2. La caja debe mostrar una luz roja (captura de la orografía de"
echo "     referencia). Si no aparece, pulsa '2' para capturar."
echo "  3. Coloca el CD a la altura adecuada para que la cruz coincida con"
echo "     la del CD y pulsa '1' cuando la proyección esté en verde."
echo "  4. Repite en varios puntos hasta volver al punto de referencia inicial."
echo "  5. Modifica el relieve de la arena (haz hoyos), retira el CD y pulsa '2'."
echo "  6. Vuelve a tomar varios puntos de referencia con '1'."
echo ""

read -p "¿Lanzar CalibrateProjector ahora? [s/N]: " resp_b
case "$resp_b" in
    [sS]|[sS][iI])
        if [ -d "$SARNDBOX_DIR" ]; then
            cd "$SARNDBOX_DIR"
            ./bin/CalibrateProjector
        else
            echo "No se encuentra $SARNDBOX_DIR. Ejecuta primero 04_install_sarndbox.sh."
        fi
        ;;
    *)
        echo "Paso omitido."
        ;;
esac

echo ""
echo "Calibración finalizada (o pasos omitidos según tu elección)."
echo "Cuando todo esté listo, ejecuta SARndbox con:"
echo "  cd ~/src/SARndbox-2.8 && ./bin/SARndbox -uhm -fpv"
echo "o usa el icono de escritorio creado por 05_setup_shortcuts.sh."
