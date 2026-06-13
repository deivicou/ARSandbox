#!/bin/bash
###############################################################################
# 01_install_nvidia_driver.sh
#
# Instala un driver de Nvidia compatible con el proyecto ARSandbox.
#
# Recomendaciones según el README original:
#   - Nvidia serie 1650  -> driver 440 (recomendado)
#   - Nvidia serie 3050  -> driver 530
#
# Si tu gráfica es distinta, puedes elegir el driver manualmente desde el
# "Gestor de controladores" (Driver Manager) del sistema, o indicar la
# versión deseada cuando este script te lo solicite.
#
# IMPORTANTE: tras instalar el driver es necesario REINICIAR el equipo.
###############################################################################

set -e

echo "Instalación del driver de Nvidia"
echo "---------------------------------"
echo "Drivers recomendados:"
echo "  - Nvidia serie 1650 -> nvidia-driver-440 (recomendado)"
echo "  - Nvidia serie 3050 -> nvidia-driver-530"
echo ""

read -p "Indica la versión de driver a instalar (por defecto 440): " DRIVER_VERSION
DRIVER_VERSION=${DRIVER_VERSION:-440}

echo ""
echo "Se instalará: nvidia-driver-$DRIVER_VERSION"
read -p "¿Continuar? [s/N]: " resp
case "$resp" in
    [sS]|[sS][iI])
        ;;
    *)
        echo "Instalación del driver cancelada por el usuario."
        exit 0
        ;;
esac

echo ""
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

echo ""
echo "######################################################################"
echo "# IMPORTANTE: es recomendable REINICIAR el equipo en este punto      #"
echo "# antes de instalar el driver, tal y como indica la documentación   #"
echo "# original. Si continúas sin reiniciar, la instalación puede        #"
echo "# completarse igualmente, pero se recomienda reiniciar después.     #"
echo "######################################################################"
echo ""

read -p "¿Reiniciar ahora antes de continuar? [s/N]: " resp_reboot
case "$resp_reboot" in
    [sS]|[sS][iI])
        echo "Reiniciando el equipo. Vuelve a ejecutar este script tras el reinicio."
        sudo reboot
        exit 0
        ;;
    *)
        echo "Continuando sin reiniciar."
        ;;
esac

echo ""
echo "Instalando nvidia-driver-$DRIVER_VERSION y nvidia-settings..."
sudo apt install -y "nvidia-driver-$DRIVER_VERSION" nvidia-settings

echo ""
echo "Actualizando initramfs..."
sudo update-initramfs -u

echo ""
echo "Driver instalado. Se recomienda REINICIAR el equipo ahora para que"
echo "el nuevo driver de Nvidia se cargue correctamente."
read -p "¿Reiniciar ahora? [s/N]: " resp_final
case "$resp_final" in
    [sS]|[sS][iI])
        sudo reboot
        ;;
    *)
        echo "Recuerda reiniciar el equipo manualmente antes de continuar con la instalación."
        ;;
esac
