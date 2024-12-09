#!/bin/bash

# Configuración inicial
API_KEY="API_KEY"  # Reemplaza con tu clave de API

PROTOCOLS=("ICMP" "TCP" "UDP")
DELAY=10
IP_BASE="DIRECCION_IP_DE_TU_SONDA"

    PORT_ICMP="21"  # Obtener el probe correspondiente para la IP
    PORT_TCP="21"   # Obtener el probe correspondiente para la IP
    PORT_UDP="21"   # Obtener el probe correspondiente para la IP

    # Crear el JSON dinámico
    JSON_PAYLOAD=$(cat <<EOF
{
  "definitions": [
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Inverse traceroute measurement from $IP using ICMP with probe $PROBE",
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
      "target": "$IP_BASE",
      "PORT": "$PORT_ICMP"
    },
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Inverse traceroute measurement from $IP using UDP with probe $PROBE",
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
      "target": "$IP_BASE",
      "port": "$PORT_UDP"
    },
    {
      "type": "traceroute",
      "af": 4,
      "resolve_on_probe": true,
      "description": "Inverse traceroute measurement from $IP using TCP with probe $PROBE",
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
      "target": "$IP_BASE",
      "port": "$PORT_TCP"
    }
  ],
  "probes": [
    {
      "type": "probes",
      "value": "7344,1000916,7047,6937",
      "requested": 4
    }
  ],
  "is_oneoff": true,
  "bill_to": "TU_CORREO_REGISTRADO_EN_RIPE"
}
EOF
    )

    # Hacer la solicitud con curl
    echo "Enviando solicitud para IP: 190.20.202.127 y probes: 7344,1000916,7047,6937"
    curl -H "Authorization: Key $API_KEY" \
         -H "Content-Type: application/json" \
         -X POST \
         -d "$JSON_PAYLOAD" \
         https://atlas.ripe.net/api/v2/measurements/

    echo # Línea en blanco para legibilidad
