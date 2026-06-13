#!/bin/bash
###############################################################################
# install.sh
#
# Script orquestador para la instalación completa del ARSandbox.
#
# Ejecuta, en orden, todos los pasos necesarios:
#   1. Comprobación de requisitos (SO, gráfica, paquetes básicos)
#   2. Instalación del driver Nvidia
#   3. Instalación de Vrui VR Development Toolkit 8.0-002
#   4. Instalación de Kinect 3D Video Package 3.10
#   5. Compilación de Augmented Reality Sandbox 2.8
#   6. Creación de accesos directos (script de arranque + icono de escritorio)
#   7. Apertura de las herramientas de calibración (paso manual/interactivo)
#
# Cada paso pide confirmación antes de ejecutarse, de forma que se pueda
# repetir un paso concreto si falla, o saltarlo si ya se hizo previamente.
#
# Uso:
#   chmod +x scripts/*.sh
#   ./scripts/install.sh
###############################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Función auxiliar: pide confirmación antes de ejecutar un paso
confirm_and_run() {
    local description="$1"
    local script="$2"

    echo ""
    echo "==> $description"
    read -p "    ¿Ejecutar este paso? [s/N]: " respuesta
    case "$respuesta" in
        [sS]|[sS][iI])
            bash "$SCRIPT_DIR/$script"
            ;;
        *)
            echo "    Paso omitido."
            ;;
    esac
}

echo "######################################################################"
echo "#                Instalación del proyecto ARSandbox                #"
echo "######################################################################"

confirm_and_run "Paso 1/6: Comprobar requisitos del sistema (SO, gráfica, paquetes)" \
    "00_check_requirements.sh"

confirm_and_run "Paso 2/6: Instalar el driver de Nvidia" \
    "01_install_nvidia_driver.sh"

confirm_and_run "Paso 3/6: Instalar Vrui VR Development Toolkit 8.0-002" \
    "02_install_vrui.sh"

confirm_and_run "Paso 4/6: Instalar Kinect 3D Video Package 3.10" \
    "03_install_kinect.sh"

confirm_and_run "Paso 5/6: Compilar Augmented Reality Sandbox 2.8" \
    "04_install_sarndbox.sh"

confirm_and_run "Paso 6/6: Crear accesos directos (script de arranque + icono de escritorio)" \
    "05_setup_shortcuts.sh"

echo ""
echo "######################################################################"
echo "# Instalación de software completada.                               #"
echo "#                                                                    #"
echo "# Quedan pendientes los pasos de CALIBRACIÓN, que son manuales:     #"
echo "#   - Calibración de la Kinect (cámara + plano de la arena)          #"
echo "#   - Calibración del proyector                                     #"
echo "#                                                                    #"
echo "# Puedes lanzar la ayuda interactiva de calibración con:            #"
echo "#   ./scripts/06_calibration.sh                                     #"
echo "#                                                                    #"
echo "# Consulta la sección 'Calibración' del README.md para el detalle.  #"
echo "######################################################################"
