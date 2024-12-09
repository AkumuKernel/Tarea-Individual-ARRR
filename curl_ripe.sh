#!/bin/bash

# Configuración inicial
API_KEY="API-KEY"  # Reemplaza con tu clave de API

# Asignar un probe único a cada IP
declare -A IP_TO_PROBE
IP_TO_PROBE["185.131.204.20"]="7344"
IP_TO_PROBE["5.161.76.19"]="1000916"
IP_TO_PROBE["80.77.4.60"]="7047"
IP_TO_PROBE["130.104.228.159"]="6937"

# Asignar un puerto único a cada IP
declare -A IP_TO_PORT_ICMP
IP_TO_PORT_ICMP["185.131.204.20"]="80"
IP_TO_PORT_ICMP["5.161.76.19"]="80"
IP_TO_PORT_ICMP["80.77.4.60"]="80"
IP_TO_PORT_ICMP["130.104.228.159"]="80"

# Asignar un puerto único a cada IP
declare -A IP_TO_PORT_UDP
IP_TO_PORT_UDP["185.131.204.20"]="80"
IP_TO_PORT_UDP["5.161.76.19"]="53"
IP_TO_PORT_UDP["80.77.4.60"]="80"
IP_TO_PORT_UDP["130.104.228.159"]="80"

# Asignar un puerto único a cada IP
declare -A IP_TO_PORT_TCP
IP_TO_PORT_TCP["185.131.204.20"]="80"
IP_TO_PORT_TCP["5.161.76.19"]="22"
IP_TO_PORT_TCP["80.77.4.60"]="22"
IP_TO_PORT_TCP["130.104.228.159"]="80"

PROTOCOLS=("ICMP" "TCP" "UDP")
INTERVAL=300
DELAY=10

# Iterar sobre las combinaciones de IPs y protocolos
for IP in "${!IP_TO_PROBE[@]}"; do  # Iterar sobre las claves del arreglo asociativo
    PROBE="PROBE_ID"  # Obtener el probe correspondiente para la IP
    PORT_ICMP="${IP_TO_PORT_ICMP[$IP]}"  # Obtener el probe correspondiente para la IP
    PORT_TCP="${IP_TO_PORT_TCP[$IP]}"
    PORT_UDP="${IP_TO_PORT_UDP[$IP]}"

    # Crear el JSON dinámico
    JSON_PAYLOAD=$(cat <<EOF
{
  "definitions": [
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Traceroute measurement to $IP using ICMP with probe $PROBE",
      "response_timeout": 4000,
      "protocol": "ICMP",
      "packets": 3,
      "size": 48,
      "first_hop": 1,
      "max_hops": 32,
      "paris": 16,
      "destination_option_size": 0,
      "hop_by_hop_option_size": 0,
      "dont_fragment": false,
      "skip_dns_check": false,
      "target": "$IP",
      "PORT": "$PORT_ICMP"
    },
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Traceroute measurement to $IP using UDP with probe $PROBE",
      "response_timeout": 4000,
      "protocol": "UDP",
      "packets": 3,
      "size": 48,
      "first_hop": 1,
      "max_hops": 32,
      "paris": 16,
      "destination_option_size": 0,
      "hop_by_hop_option_size": 0,
      "dont_fragment": false,
      "skip_dns_check": false,
      "target": "$IP",
      "port": "$PORT_UDP"
    },
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Traceroute measurement to $IP using TCP with probe $PROBE",
      "response_timeout": 4000,
      "protocol": "TCP",
      "packets": 3,
      "size": 48,
      "first_hop": 1,
      "max_hops": 32,
      "paris": 16,
      "destination_option_size": 0,
      "hop_by_hop_option_size": 0,
      "dont_fragment": false,
      "skip_dns_check": false,
      "target": "$IP",
      "port": "$PORT_TCP"
    }
  ],
  "probes": [
    {
      "type": "probes",
      "value": "$PROBE",
      "requested": 1
    }
  ],
  "is_oneoff": true,
  "bill_to": "TU_CORREO"
}
EOF
    )

    # Hacer la solicitud con curl
    echo "Enviando solicitud para IP: $IP y probe: $PROBE"
    curl -H "Authorization: Key $API_KEY" \
         -H "Content-Type: application/json" \
         -X POST \
         -d "$JSON_PAYLOAD" \
         https://atlas.ripe.net/api/v2/measurements/

    echo # Línea en blanco para legibilidad
done
