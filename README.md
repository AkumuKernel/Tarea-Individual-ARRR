# Tarea-Individual-ARRR

Este repositorio es parte de la tarea hecha para la asignatura de Algoritmos de Ruteo y Redes Resilientes 2-2024, que consiste en la automatización de la generación de traceroute usando tanto Scamper como RIPE atlas, los requisitos para replicar esta tarea son:
- Dispotivo con GNU/Linux
- [Docker](https://www.docker.com/)/[Podman](https://podman.io/)
- [Curl](https://curl.se/)
- [Jq](https://jqlang.github.io/jq/)
- [Tcpdump](https://www.tcpdump.org/)
- [Scamper](https://www.caida.org/catalog/software/scamper/)
- [Wireshark](https://www.wireshark.org/)
- [Tshark](https://tshark.dev/)
- [Bash](https://www.gnu.org/software/bash/)
- [Tener una API key de RIPE atlas](https://atlas.ripe.net/)


## Traceroute con Scamper

Para poder utilizar scamper luego de instalar los archivos necesarios, se debe hacer la siguiente ejecución
```sh
sh run_scamper.sh
```
Esto generará las carpetas de:

- `/trace_output`
- `/pcap_output`
- `/json`
- `/json_transformed`

Otra forma de hacer esto es usando el siguiente comando:
```sh
sh scamper_run.sh && \
sh curar_json.sh
```

Generando las rutas de traceroute requeridas para esta tarea. Es importantisimo cambiar la línea del script, agregando la dirección IP de tu dispositivo local (línea 18):
- [run_scamper.sh](https://github.com/AkumuKernel/Tarea-Individual-ARRR/blob/master/run_scamper.sh#L18)
- [scamper_run.sh](https://github.com/AkumuKernel/Tarea-Individual-ARRR/blob/master/scamper_run.sh#L18)

## Traceroute con RIPE

### Generación del Docker

Se debe ejecutar los siguientes comandos:
```sh
git clone https://github.com/Jamesits/docker-ripe-atlas.git
cd docker-ripe-atlas
docker-compose pull
docker-compose up -d
```

Teniendo el docker ejecutado, se debe ejecutar el siguiente comando:
```sh
cat /var/atlas-probe/etc/probe_key.pub
```
Luego debes [registrar la sonda](https://atlas.ripe.net/apply/swprobe/) con el resultado que te da `cat`, así generando la sonda, que para obtener la IP tarda un aproximado de 15 minutos.


### Generación de peticiones
Para poder utilizar las peticiones de RIPE, para el traceroute desde tu sonda, luego de generar el contenedor, se debe ejecutar el siguiente comando:
```sh
sh curl_ripe.sh
```

Generando las rutas traceroute en RIPE, hay que modificar las líneas 4, 40 y 115, con los datos correspondientes del siguiente programa:
- [curl_ripe.sh](https://github.com/AkumuKernel/Tarea-Individual-ARRR/blob/master/curl_ripe.sh#L4)

Para el traceroute inverso, se debe utilizar el siguiente comando:
```sh
sh trace_inverso_ripe.sh
```
Generando las rutas traceroute en RIPE, hay que modificar las líneas 4, 8 y 84, con los datos correspondientes del siguiente programa:
- [trace_inverso_ripe.sh](https://github.com/AkumuKernel/Tarea-Individual-ARRR/blob/master/trace_inverso_ripe.sh#L4)

### Traceroute desde la sonda de origen (dispositivo personal con docker)
- [Traceroute con la IP 130.104.228.159 ICMP](https://atlas.ripe.net/measurements/84258148/results)
- [Traceroute con la IP 130.104.228.159 UDP](https://atlas.ripe.net/measurements/84258149/results)
- [Traceroute con la IP 130.104.228.159 TCP](https://atlas.ripe.net/measurements/84258150/results)
- [Traceroute con la IP 185.131.203.20 ICMP](https://atlas.ripe.net/measurements/84258151/results)
- [Traceroute con la IP 185.131.203.20 UDP](https://atlas.ripe.net/measurements/84258152/results)
- [Traceroute con la IP 185.131.203.20 TCP](https://atlas.ripe.net/measurements/84258153/results)
- [Traceroute con la IP 80.77.4.60 ICMP](https://atlas.ripe.net/measurements/84258154/results)
- [Traceroute con la IP 80.77.4.60 UDP](https://atlas.ripe.net/measurements/84258155/results)
- [Traceroute con la IP 80.77.4.60 TCP](https://atlas.ripe.net/measurements/84258156/results)
- [Traceroute con la IP 5.161.76.19 ICMP](https://atlas.ripe.net/measurements/84258157/results)
- [Traceroute con la IP 5.161.76.19 UDP](https://atlas.ripe.net/measurements/84258158/results)
- [Traceroute con la IP 5.161.76.19 TCP](https://atlas.ripe.net/measurements/84258159/results)

### Traceroute inverso hacia la sonda de origen (dispositivo personal con docker)
- [Traceroute inverso con ICMP](https://atlas.ripe.net/measurements/84258163/results)
- [Traceroute inverso con UDP](https://atlas.ripe.net/measurements/84258164/results)
- [Traceroute inverso con TCP](https://atlas.ripe.net/measurements/84258165/results)
