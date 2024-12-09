#!/bin/bash

# Directorio de JSON
json_dir="."

# Iterar por cada archivo JSON en el directorio
for file in "$json_dir"/*.json; do
    if [[ -f "$file" ]]; then
        # Crear el nombre del archivo CSV basado en el nombre del archivo JSON
        csv_file="${file%.json}.csv"
        
        echo "Procesando $file... Creando $csv_file"
        
        # Extraer direcciones IP de los nodos de primer nivel y guardarlas en el archivo CSV
        jq -r '.data[]?.nodes[]?.addr? // empty' "$file" >> "$csv_file"
        
        # Agregar una línea vacía al final del archivo
        echo "" >> "$csv_file"
        
        echo "Listo. Archivo generado: $csv_file"
    fi
done

echo "Procesamiento completado para todos los archivos."

