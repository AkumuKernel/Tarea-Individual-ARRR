#!/bin/bash

# Directorio que contiene los archivos CSV (cambiar si es diferente)
directorio="./"

# Archivo CSV de salida
archivo_salida="resultados.csv"

# Crear el encabezado para el archivo de salida
echo "Nombre_Archivo,Latencia_Promedio,Desviacion_Estandar" > "$archivo_salida"

echo "Calculando latencia promedio y desviación estándar para todos los archivos CSV en el directorio..."

# Recorrer todos los archivos CSV en el directorio
for archivo_csv in "$directorio"*.csv; do
    # Verificar si el archivo existe para evitar errores
    if [[ -f "$archivo_csv" ]]; then
        # Calcular la latencia promedio
        latencia_promedio=$(awk 'NR>1 {sum+=$NF; count++} END {print sum/count}' "$archivo_csv")
        
        # Calcular la desviación estándar
        desviacion_estandar=$(awk -v prom="$latencia_promedio" 'NR>1 {sum_sq += ($NF - prom)^2; count++} END {if (count > 0) print sqrt(sum_sq / count); else print 0}' "$archivo_csv")
        
        # Guardar los resultados en el archivo de salida CSV
        echo "$(basename "$archivo_csv"),$latencia_promedio,$desviacion_estandar" >> "$archivo_salida"
    fi
done

echo "Cálculo completado. Los resultados se han guardado en '$archivo_salida'."
