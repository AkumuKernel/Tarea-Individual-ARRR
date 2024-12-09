#!/bin/bash

# Directorio de entrada
input_dir="./json"
# Directorio de salida
output_dir="./json_transformed"

# Verifica si el directorio de entrada existe
if [[ ! -d $input_dir ]]; then
    echo "El directorio $input_dir no existe."
    exit 1
fi

# Crea el directorio de salida si no existe
mkdir -p "$output_dir"

# Procesa cada archivo en el directorio de entrada
for input_file in "$input_dir"/*.json; do
    # Verifica que haya archivos JSON en el directorio
    if [[ ! -e $input_file ]]; then
        echo "No se encontraron archivos JSON en $input_dir."
        exit 1
    fi

    # Nombre del archivo de salida
    output_file="$output_dir/$(basename "$input_file")"

    # Construye el JSON estructurado
    {
        echo '{ "data": ['
        # Lee cada línea del archivo y agrega comas excepto la última
        awk 'NR > 1 { print "," } { printf $0 }' "$input_file"
        echo '] }'
    } > "$output_file"

    echo "Archivo transformado: $output_file"
done

echo "Todos los archivos JSON han sido procesados y guardados en $output_dir."
