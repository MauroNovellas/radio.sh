#!/bin/bash
# Script para reproducir estaciones de radio en línea usando cvlc

# Función para verificar e instalar cvlc si es necesario
verificar_e_instalar_cvlc() {
    if ! command -v cvlc &> /dev/null; then
        echo "cvlc no está instalado. Intentando instalarlo..."
        sudo apt-get update
        sudo apt-get install -y vlc
        if ! command -v cvlc &> /dev/null; then
            echo "Error: No se pudo instalar cvlc. Por favor, instálelo manualmente."
            exit 1
        fi
    fi
}

# Función para mostrar el menú de estaciones de radio
mostrar_menu() {
    clear  # Limpia la terminal antes de mostrar el menú
    echo "-== Radios ==-"
    for i in "${!RADIO_NOMBRES[@]}"; do
        echo "$((i + 1))) ${RADIO_NOMBRES[$i]}"
    done
    echo "Presione '+' para subir el volumen, '-' para bajarlo, 'q' para salir, 'm' para volver al menú."
}

# Función para ejecutar la estación de radio seleccionada
ejecutar_radio() {
    cvlc "${RADIO_URLS[$1]}" &
    PID_CVLC=$!
}

# Función para controlar el volumen, salida y volver al menú
control_teclado() {
    while true; do
        read -rsn1 input
        case "$input" in
            '+') pactl set-sink-volume @DEFAULT_SINK@ +10% ;;
            '-') pactl set-sink-volume @DEFAULT_SINK@ -10% ;;
            'q') 
                kill $PID_CVLC
                break ;;
            'm') 
                kill $PID_CVLC
                return 1 ;; # Volver al menú principal
        esac
    done
}

# Función para validar la selección del usuario
validar_seleccion() {
    if [[ $1 =~ ^[1-${#RADIO_NOMBRES[@]}]$ ]]; then
        ejecutar_radio $((estacion-1))
        if control_teclado; then
            return 1
        fi
    else
        echo "Opción no válida. Por favor, seleccione un número entre 1 y ${#RADIO_NOMBRES[@]}."
    fi
}

# Inicializar URLs y nombres de las radios
RADIO_URLS=(
"https://livefastly-webs.ondacero.es/barcelona-pull/audio/chunklist.m3u8"
"https://25653.live.streamtheworld.com/CADENASER.mp3"
"https://flucast24-h-cloud.flumotion.com/cope/net1.mp3"
"https://rtvelivestream.akamaized.net/rtvesec/rne/rne_r1_main.m3u8"
"https://rtvelivestream.akamaized.net/rtvesec/rne/rne_r5_madrid_main.m3u8"
"https://playerservices.streamtheworld.com/api/livestream-redirect/RAC_1.mp3"
"https://directes-radio-int.ccma.cat/live-content/catalunya-radio-hls/master.m3u8"
"https://rockfm-cope.flumotion.com/playlist.m3u8"
)
RADIO_NOMBRES=(
"Onda Cero Barcelona"
"SER Barcelona"
"COPE"
"Radio Nacional RNE1"
"Radio Nacional RNE5"
"RAC1"
"Catalunya Radio"
"Rock FM"
)

# Verificar e instalar cvlc
verificar_e_instalar_cvlc

# Manejar la interrupción del script (Ctrl+C)
trap 'kill $PID_CVLC; exit' SIGINT

# Bucle del menú principal
while true; do
    mostrar_menu
    read -p "Seleccione una estación (o 'q' para salir): " estacion
    if [[ "$estacion" == "q" ]]; then
        break
    fi
    validar_seleccion $estacion
done
