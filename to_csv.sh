#!/bin/bash

# Directorios
INPUT_DIR="./pcap_output"   # Directorio con los archivos .pcap
OUTPUT_DIR="./csv_output"   # Directorio para guardar los archivos CSV

# Crear el directorio de salida si no existe
mkdir -p "$OUTPUT_DIR"

# Procesar cada archivo .pcap en el directorio
for PCAP_FILE in "$INPUT_DIR"/*.pcap; do
    # Obtener el nombre base del archivo sin la extensión
    BASENAME=$(basename "$PCAP_FILE" .pcap)
    
    # Extraer el método (primera parte del nombre después de "trace -P" o directamente)
    if [[ "$BASENAME" == trace\ -P* ]]; then
        METHOD=$(echo "$BASENAME" | cut -d'_' -f1 | sed 's/trace -P //')
    else
        METHOD=$(echo "$BASENAME" | cut -d'_' -f1)
    fi
    
    # Asignar el filtro según el método detectado
    case $METHOD in
        "icmp")
            FILTER="icmp"
            ;;
        "icmp-paris")
            FILTER="icmp"
            ;;
        "udp")
            FILTER="udp"
            ;;
        "udp-paris")
            FILTER="udp"
            ;;
        "tcp")
            FILTER="tcp"
            ;;
        "tcp-ack")
            FILTER="tcp && tcp.flags.ack == 1"
            ;;
        "tracelb")
            FILTER="udp || icmp"
            ;;
        *)
            echo "Método desconocido para $PCAP_FILE, saltando..."
            continue
            ;;
    esac

    # Archivo de salida CSV
    CSV_FILE="$OUTPUT_DIR/${BASENAME// /_}.csv"
    
    # Filtrar y exportar a CSV
    echo "Procesando $PCAP_FILE con método $METHOD..."
    tshark -r "$PCAP_FILE" \
        -T fields \
        -e frame.number \
        -e frame.time \
        -e ip.src \
        -e ip.dst \
        -e udp.port \
        -e icmp.type \
        -e tcp.flags \
        -e frame.time_delta \
        -Y "$FILTER" \
        > "$CSV_FILE"
        
    echo "Guardado en $CSV_FILE"
done

echo "Procesamiento completado. Archivos CSV guardados en $OUTPUT_DIR"
