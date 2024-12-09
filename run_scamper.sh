#!/bin/bash

# Lista de IPs destino
destinos=("185.131.204.20" "5.161.76.19" "80.77.4.60" "130.104.228.159")

# Métodos de traza que deseas usar
metodos=("trace -P icmp" "trace -P udp" "trace -P tcp" "trace -P tcp-ack" "trace -P udp-paris" "trace -P icmp-paris" "tracelb")

# Directorio donde se guardarán los resultados de las trazas
traces_output_dir="traces_output"
mkdir -p "$traces_output_dir"

# Directorio para capturas de tcpdump
pcap_output_dir="pcap_output"
mkdir -p "$pcap_output_dir"

# Tu IP de origen (reemplazar con tu IP real)
mi_ip_origen="TU_DIRECCION_IP" # Cambia esto por tu IP real

# Ejecutar trazas con Scamper
echo "Iniciando trazas y capturas con tcpdump..."
for ip in "${destinos[@]}"; do
  for metodo in "${metodos[@]}"; do
    # Nombre base para los archivos de salida
    base_name="${metodo}_${ip}"
    
    # Archivos de salida
    output_file="${traces_output_dir}/${base_name}.warts"
    pcap_file="${pcap_output_dir}/${base_name}.pcap"
    
    # Iniciar tcpdump para capturar todo el tráfico con tu IP como fuente o destino
    echo "Iniciando tcpdump para capturar todo el tráfico con la IP $mi_ip_origen..."
    sudo tcpdump -i any "host $mi_ip_origen" -w "$pcap_file" &
    TCPDUMP_PID=$!
    
    # Ejecutar Scamper
    echo "Ejecutando Scamper para IP: $ip con método: $metodo"
    scamper -c "$metodo" -i "$ip" -o "$output_file"
    
    # Detener tcpdump después de la traza
    echo "Deteniendo captura tcpdump para IP: $ip con método: $metodo"
    sudo kill "$TCPDUMP_PID"
    wait "$TCPDUMP_PID" 2>/dev/null
  done
done

echo "Trazas y capturas completadas. Los resultados se guardaron en $traces_output_dir y $pcap_output_dir."

# Directorio de salida para los archivos .json
json_output_dir="json"
mkdir -p "$json_output_dir"

# Convertir archivos .warts a .json
echo "Iniciando conversión de .warts a .json..."
for warts_file in "$traces_output_dir"/*.warts; do
  if [[ -f "$warts_file" ]]; then
    # Obtener el nombre base del archivo (sin la ruta completa)
    base_name=$(basename "$warts_file" .warts)
    
    # Ruta del archivo .json de salida
    json_file="$json_output_dir/${base_name}.json"
    
    # Convertir .warts a .json
    echo "Convirtiendo $warts_file a $json_file"
    sc_warts2json "$warts_file" > "$json_file"
  fi
done

echo "Conversión completada. Los archivos .json se guardaron en $json_output_dir."

# Transformar archivos JSON al formato estructurado
json_transformed_dir="json_transformed"
mkdir -p "$json_transformed_dir"

echo "Iniciando transformación de archivos JSON..."
for json_file in "$json_output_dir"/*.json; do
  if [[ -f "$json_file" ]]; then
    # Obtener el nombre base del archivo
    base_name=$(basename "$json_file")
    
    # Archivo transformado
    transformed_file="$json_transformed_dir/$base_name"
    
    # Transformar JSON
    {
      echo '{ "data": ['
      awk 'NR > 1 { print "," } { printf $0 }' "$json_file"
      echo '] }'
    } > "$transformed_file"
    
    echo "Archivo transformado: $transformed_file"
  fi
done

echo "Transformación de JSON completada. Los resultados se guardaron en $json_transformed_dir."
