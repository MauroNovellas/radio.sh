# Radio Streamer Script

Este script de Bash permite a los usuarios reproducir estaciones de radio en línea utilizando `cvlc`, la versión de línea de comandos de VLC.

## Características

- Reproducción de múltiples estaciones de radio en línea.
- Control de volumen integrado.
- Navegación sencilla a través de un menú interactivo.
- Posibilidad de regresar al menú principal sin salir del script.
- Limpieza de la terminal para una mejor experiencia de usuario.

## Requisitos

- `cvlc` (VLC para la línea de comandos)
- Sistema operativo basado en Unix/Linux
- `bash` shell

## Instalación

1. Clona este repositorio o descarga el script directamente.
2. Otorga permisos de ejecución al script:

    ```bash
    chmod +x radio.sh
    ```

3. Ejecuta el script:

    ```bash
    ./radio.sh
    ```

## Uso

Después de iniciar el script, se presentará un menú con las estaciones de radio disponibles. Utiliza los números para seleccionar una estación. Una vez seleccionada, puedes:

- Aumentar el volumen con `+`.
- Disminuir el volumen con `-`.
- Volver al menú principal con `m`.
- Salir del script con `q`.

## Contribuciones

Las contribuciones son bienvenidas. Si tienes sugerencias o mejoras, siéntete libre de realizar un fork y abrir un pull request, o simplemente abrir un issue en el repositorio.
