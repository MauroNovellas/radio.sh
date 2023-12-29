#!/bin/bash
# Script para reproducir estaciones de radio en línea usando cvlc

# Verificar si cvlc está instalado
if ! command -v cvlc &> /dev/null; then
    echo "cvlc no está instalado. Intentando instalarlo..."
    sudo apt-get update
    sudo apt-get install -y vlc
fi

# URLs y nombres de las radios
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


# Mostrar menú
mostrar_menu() {
    echo "-== Radios ==-"
    for i in "${!RADIO_NOMBRES[@]}"; do
        echo "$((i + 1))) ${RADIO_NOMBRES[$i]}"
    done
    echo "Presione '+' para subir el volumen, '-' para bajarlo y 'q' para salir."
}

# Ejecutar radio
ejecutar_radio() {
    cvlc "${RADIO_URLS[$1]}" &
    PID_CVLC=$!
}

# Control de volumen y salida
control_teclado() {
    while true; do
        read -rsn1 input
        if [ "$input" = '+' ]; then
            pactl set-sink-volume @DEFAULT_SINK@ +10%
        elif [ "$input" = '-' ]; then
            pactl set-sink-volume @DEFAULT_SINK@ -10%
        elif [ "$input" = 'q' ]; then
            kill -9 $PID_CVLC
            break
        fi
    done
}

# Manejar la interrupción del script (Ctrl+C)
trap 'kill -9 $PID_CVLC; exit' SIGINT

# Menú principal
mostrar_menu
read -p "Seleccione una estación: " estacion

if [[ $estacion =~ ^[1-${#RADIO_NOMBRES[@]}]$ ]]; then
    ejecutar_radio $((estacion-1))
    control_teclado
else
    echo "Opción no válida."
fi
