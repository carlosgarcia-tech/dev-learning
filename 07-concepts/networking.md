# Networking

> Conceptos fundamentales de redes para programadores. Desde cómo viaja un paquete hasta cómo se escala un servicio con balanceo de carga.

## Índice

1. [Modelo OSI](#modelo-osi)
2. [Modelo TCP/IP](#modelo-tcpip)
3. [Direccionamiento IP y CIDR](#direccionamiento-ip-y-cidr)
4. [Subnetting y NAT](#subnetting-y-nat)
5. [DNS](#dns)
6. [Puertos](#puertos)
7. [TCP vs UDP](#tcp-vs-udp)
8. [HTTP / HTTPS](#http--https)
9. [Routing](#routing)
10. [Firewalls](#firewalls)
11. [VPN](#vpn)
12. [Load Balancing](#load-balancing)

---

## Modelo OSI

El modelo OSI (Open Systems Interconnection) es un marco teórico de 7 capas que describe cómo los datos viajan desde una aplicación hasta el medio físico. Es un modelo de referencia; en internet se usa más el modelo TCP/IP.

| Capa | Nombre | Unidad de datos | Ejemplos | Dispositivos |
|------|--------|-----------------|----------|--------------|
| 7 | Aplicación | Data | HTTP, DNS, FTP, SMTP | Gateway de nivel 7 |
| 6 | Presentación | Data | TLS/SSL, JPEG, ASCII | — |
| 5 | Sesión | Data | Sockets, NetBIOS, RPC | — |
| 4 | Transporte | Segmento | TCP, UDP | Firewall de nivel 4 |
| 3 | Red | Paquete | IP, ICMP | Router |
| 2 | Enlace | Trama | Ethernet, Wi-Fi, ARP | Switch, Bridge |
| 1 | Física | Bit | Cables, fibra, radio | Hub, repetidor |

```
Capa 7:  [ Datos de la aplicación (HTTP request) ]
Capa 6:  [ Cifrado TLS ]
Capa 5:  [ Control de sesión ]
Capa 4:  [ TCP header | Datos ]        -> Segmento
Capa 3:  [ IP header  | TCP | Datos ]  -> Paquete
Capa 2:  [ Ethernet hdr | IP | TCP | Datos | FCS ] -> Trama
Capa 1:  [ Bits por el cable: 101010... ]
```

### Regla mnemotécnica (de abajo hacia arriba)

**P**or **T**anta **R**ed **N**adie **S**abe **P**rogramar **A**plicaciones

- Física, Enlace, Red, Transporte, Sesión, Presentación, Aplicación.

---

## Modelo TCP/IP

El modelo TCP/IP es el que realmente usa internet. Fusiona varias capas de OSI en solo 4.

| Capa TCP/IP | Capas OSI equivalentes | Protocolos |
|-------------|------------------------|------------|
| Aplicación | Aplicación + Presentación + Sesión | HTTP, HTTPS, DNS, FTP, SMTP, SSH |
| Transporte | Transporte | TCP, UDP |
| Internet | Red | IP, ICMP, ARP |
| Acceso a red | Enlace + Física | Ethernet, Wi-Fi |

### Encapsulamiento

Cada capa añade su propia cabecera. Cuando un paquete baja por la pila, se encapsula; cuando sube, se desencapsula.

```
Aplicación:   "GET / HTTP/1.1"
Transporte:  [TCP: puerto origen, destino, seq, ack]
Internet:    [IP: IP origen, destino, TTL]
Acceso:      [Ethernet: MAC origen, destino]
```

---

## Direccionamiento IP y CIDR

Una dirección IPv4 tiene 32 bits, escritos como 4 octetos decimales: `192.168.1.10`.

### Clases (históricas, hoy obsoletas por CIDR)

| Clase | Rango | Máscara por defecto | Uso |
|-------|-------|---------------------|-----|
| A | 1.0.0.0 – 126.255.255.255 | /8 | Redes gigantes |
| B | 128.0.0.0 – 191.255.255.255 | /16 | Redes medianas |
| C | 192.0.0.0 – 223.255.255.255 | /24 | Redes pequeñas |
| D | 224.0.0.0 – 239.255.255.255 | — | Multicast |
| E | 240.0.0.0 – 255.255.255.255 | — | Reservado |

### Rangos privados (RFC 1918)

No se enrutan por internet:

- `10.0.0.0/8` — 16 millones de hosts
- `172.16.0.0/12` — 1 millón de hosts
- `192.168.0.0/16` — 65 536 hosts

### CIDR (Classless Inter-Domain Routing)

La notación CIDR expresa cuántos bits son de red y cuántos de host: `IP/prefijo`.

| Notación | Máscara | Hosts útiles | Tamaño |
|----------|---------|--------------|--------|
| `/24` | 255.255.255.0 | 254 | Subred pequeña |
| `/16` | 255.255.0.0 | 65 534 | Red media |
| `/8` | 255.0.0.0 | 16 777 214 | Red grande |
| `/30` | 255.255.255.252 | 2 | Enlace punto a punto |
| `/32` | 255.255.255.255 | 1 | Un solo host |

**Cálculo de hosts:** `2^(32-prefijo) - 2` (se restan dirección de red y broadcast).

### IPv6

128 bits, escrito en hexadecimales: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`. Se puede comprimir omitiendo ceros: `2001:db8:85a3::8a2e:370:7334`.

---

## Subnetting y NAT

### Subnetting

Dividir una red grande en subredes más pequeñas prestándole bits de host a la parte de red.

Ejemplo: de `192.168.1.0/24` crear 4 subredes:

- Necesito 2 bits (2^2 = 4 subredes) → nuevo prefijo `/26`.
- Cada subred tiene `2^6 - 2 = 62` hosts.

```
192.168.1.0/26   -> .0  a .63    (hosts .1-.62, broadcast .63)
192.168.1.64/26  -> .64 a .127   (hosts .65-.126, broadcast .127)
192.168.1.128/26 -> .128 a .191  (hosts .129-.190, broadcast .191)
192.168.1.192/26 -> .192 a .255  (hosts .193-.254, broadcast .255)
```

### NAT (Network Address Translation)

Traduce direcciones IP privadas a una pública para acceder a internet. Resuelve el agotamiento de IPv4.

| Tipo | Descripción |
|------|-------------|
| NAT estático | 1 IP privada ↔ 1 IP pública (fija) |
| NAT dinámico | Varias IPs privadas comparten un pool de públicas |
| PAT (NAT overload) | Varias privadas → 1 pública, distinguidas por puerto (lo que hace un router doméstico) |

```
[10.0.0.5:5000] --NAT--> [203.0.113.9:54321] --> Internet
   host interno            IP pública del router
```

---

## DNS

El **DNS** (Domain Name System) traduce nombres de dominio (`example.com`) a direcciones IP (`93.184.216.34`). Es la guía telefónica de internet.

### Jerarquía

```
Raíz (.)                  <- servidores raíz: a-m.root-servers.net
└── TLD (.com)            <- gestionado por registradores
    └── example.com       <- autoritativo
        └── www           <- registro A/AAAA/CNAME
```

### Tipos de registros

| Registro | Significado | Ejemplo |
|----------|-------------|---------|
| A | Nombre → IPv4 | `example.com. A 93.184.216.34` |
| AAAA | Nombre → IPv6 | `example.com. AAAA 2606:2800:220:1::` |
| CNAME | Alias a otro nombre | `www CNAME example.com.` |
| MX | Servidor de correo | `example.com. MX 10 mail.example.com.` |
| TXT | Texto libre (SPF, DKIM, verificación) | `example.com. TXT "v=spf1 -all"` |
| NS | Servidor autoritativo | `example.com. NS ns1.example.com.` |
| SOA | Inicio de autoridad | metadatos de la zona |
| SRV | Servicio y puerto | `_sip._tcp SRV 10 50 5060 sip.example.com.` |
| PTR | IP → nombre (DNS inverso) | resolución inversa |

### Resolución paso a paso

1. El navegador consulta la caché del navegador.
2. Si no, consulta la caché del SO (`/etc/hosts`, luego resolver local).
3. Si no, consulta al **resolver recursivo** (el DNS del ISP o 8.8.8.8).
4. El resolver consulta a un **servidor raíz**, que responde con la dirección del servidor de TLD (`.com`).
5. El resolver consulta al TLD, que responde con los **servidores autoritativos** del dominio.
6. El resolver consulta al autoritativo y obtiene el registro A.
7. El resolver guarda en caché según el **TTL** y devuelve la IP al cliente.

```
Cliente -> Resolver -> Raíz -> .com -> example.com (autoritativo) -> IP
```

### Comandos útiles

```bash
dig example.com            # consulta completa
dig +short example.com    # solo la IP
dig MX example.com        # registros MX
nslookup example.com     # alternativa clásica
host example.com          # resumen simple
```

---

## Puertos

Un puerto identifica un proceso o servicio en un host. Rango: 0–65535 (16 bits).

| Rango | Nombre | Uso |
|-------|--------|-----|
| 0 – 1023 | Well-known | Servicios estándar (requieren root) |
| 1024 – 49151 | Registrados | Aplicaciones registradas |
| 49152 – 65535 | Efímeros | Puertos temporales de cliente |

### Puertos comunes

| Puerto | Protocolo | Servicio |
|--------|-----------|----------|
| 20, 21 | TCP | FTP |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 25 | TCP | SMTP |
| 53 | TCP/UDP | DNS |
| 80 | TCP | HTTP |
| 110 | TCP | POP3 |
| 123 | UDP | NTP |
| 143 | TCP | IMAP |
| 161 | UDP | SNMP |
| 443 | TCP | HTTPS |
| 3306 | TCP | MySQL |
| 5432 | TCP | PostgreSQL |
| 6379 | TCP | Redis |
| 8080 | TCP | HTTP alternativo |

```bash
ss -tlnp    # puertos TCP a la escucha
netstat -tulpn   # alternativa
lsof -i :80      # quién usa el puerto 80
```

---

## TCP vs UDP

| Característica | TCP | UDP |
|----------------|-----|-----|
| Conexión | Orientado a conexión (handshake) | Sin conexión |
| Fiabilidad | Garantiza entrega | Mejor esfuerzo |
| Orden | Orden garantizado | Sin orden |
| Velocidad | Más lento (overhead) | Más rápido |
| Cabecera | 20 bytes mínimo | 8 bytes |
| Uso | Web, correo, SSH | DNS, streaming, VoIP, juegos |

### Three-way handshake (TCP)

```
Cliente                 Servidor
  |  --- SYN (seq=x) --->   |
  |  <-- SYN-ACK (seq=y,   |
  |       ack=x+1) ---     |
  |  --- ACK (ack=y+1) ---> |
  |    [Conexión establecida] |
```

TCP garantiza entrega con números de secuencia, acuses de recibo (ACK), retransmisión y control de flujo (ventana deslizante) y control de congestión.

---

## HTTP / HTTPS

**HTTP** (HyperText Transfer Protocol) es el protocolo de la web. Opera sobre TCP (HTTP/3 usa QUIC sobre UDP).

### Estructura del mensaje

**Petición:**

```
GET /api/users/42 HTTP/1.1
Host: api.example.com
User-Agent: curl/8.0
Accept: application/json
Authorization: Bearer eyJhbGc...

<opcional cuerpo>
```

**Respuesta:**

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 87
Cache-Control: max-age=60

{"id":42,"name":"Ada"}
```

### Métodos HTTP

| Método | Seguro | Idempotente | Descripción |
|--------|--------|-------------|-------------|
| GET | Sí | Sí | Recuperar recurso |
| HEAD | Sí | Sí | Como GET pero sin cuerpo |
| POST | No | No | Crear recurso |
| PUT | No | Sí | Reemplazar recurso |
| PATCH | No | No | Modificar parcialmente |
| DELETE | No | Sí | Eliminar recurso |
| OPTIONS | Sí | Sí | Métodos permitidos |

### Códigos de estado

| Rango | Significado | Ejemplos |
|-------|-------------|----------|
| 1xx | Informativo | 101 Switching Protocols |
| 2xx | Éxito | 200 OK, 201 Created, 204 No Content |
| 3xx | Redirección | 301, 302, 304 Not Modified |
| 4xx | Error del cliente | 400, 401, 403, 404, 429 |
| 5xx | Error del servidor | 500, 502, 503, 504 |

### HTTPS

HTTPS = HTTP sobre TLS. El servidor presenta un **certificado** firmado por una **CA** que el navegador valida contra sus CA raíz de confianza.

```
Cliente                     Servidor
  | -- ClientHello -->        |
  | (TLS version, cipher     |
  |  suites, random)          |
  | <-- ServerHello --------- |
  | (certificado X.509,       |
  |  clave pública)           |
  | -- Key Exchange -->       |
  | <-- Finished ------------- |
  | [ Datos cifrados HTTP ]   |
```

---

## Routing

El enrutamiento decide por qué interfaz enviar un paquete basándose en la tabla de rutas.

### Tabla de rutas

```
Destination     Gateway         Genmask         Flags  Iface
default         192.168.1.1     0.0.0.0         UG     eth0
192.168.1.0     0.0.0.0         255.255.255.0   U      eth0
10.8.0.0        10.8.0.5        255.255.255.0   UG     tun0
```

### Tipos de enrutamiento

- **Estático:** configurado manualmente.
- **Dinámico:** aprendido con protocolos como OSPF, BGP, RIP.
  - **OSPF** (interior, estado de enlace).
  - **BGP** (entre sistemas autónomos, es lo que mantiene unido internet).

### Traceroute

Usa incrementos del campo TTL de IP para descubrir cada router en el camino:

```bash
traceroute 8.8.8.8     # Linux/macOS
tracert 8.8.8.8        # Windows
```

---

## Firewalls

Un firewall filtra tráfico según reglas (IP origen/destino, puerto, protocolo, estado).

### Tipos

| Tipo | Capa | Qué inspecciona |
|------|------|-----------------|
| Sin estado (packet filter) | 3-4 | Cada paquete por separado |
| Con estado (stateful) | 3-4 | Contexto de la conexión |
| Proxy / WAF | 7 | Contenido de la aplicación |

### Regla típica

```
iptables -A INPUT -p tcp --dport 443 -j ACCEPT   # permitir HTTPS
iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT  # SSH solo red interna
iptables -A INPUT -j DROP                          # denegar el resto
```

### Conceptos clave

- **Allowlist** (denegar por defecto, permitir lo necesario) → más seguro.
- **Denylist** (permitir por defecto, bloquear lo malo) → menos seguro.
- **NAT y firewall** suelen convivir en el mismo router doméstico.

---

## VPN

Una **VPN** (Virtual Private Network) crea un túnel cifrado entre dos puntos por una red no confiable (internet), como si estuvieran en la misma red privada.

```
[ Laptop ] ==túnel cifrado== [ Servidor VPN ] --- [ Red corporativa ]
                 \________ internet público ______/
```

### Casos de uso

- Acceso remoto a una red corporativa.
- Ocultar el tráfico al ISP o en redes Wi-Fi públicas.
- Saltarse restricciones geográficas.

### Protocolos comunes

| Protocolo | Notas |
|-----------|-------|
| OpenVPN | Libre, basado en OpenSSL, muy usado |
| WireGuard | Moderno, rápido, poco código |
| IPsec | Estándar, a nivel de kernel |
| L2TP/IPsec | Túnel + cifrado |
| SSTP | Sobre HTTPS (atraviesa firewalls) |

### Configuración típica (WireGuard)

```ini
# /etc/wireguard/wg0.conf
[Interface]
PrivateKey = <clave-privada-cliente>
Address = 10.8.0.2/24

[Peer]
PublicKey = <clave-publica-servidor>
Endpoint = vpn.example.com:51820
AllowedIPs = 0.0.0.0/0    # todo el tráfico por la VPN
```

---

## Load Balancing

El **balanceo de carga** reparte el tráfico entre varios servidores para escalar horizontalmente y aumentar la disponibilidad.

```
                    +---> Servidor 1 (192.168.1.10)
  Clientes --> LB --+---> Servidor 2 (192.168.1.11)
                    +---> Servidor 3 (192.168.1.12)
```

### Algoritmos comunes

| Algoritmo | Descripción |
|-----------|-------------|
| Round Robin | Reparte en orden cíclico |
| Least Connections | Al servidor con menos conexiones |
| IP Hash | El mismo cliente siempre al mismo servidor (sesión) |
| Weighted | Según capacidad de cada servidor |
| Random | Aleatorio |

### Capas de balanceo

- **L4 (transporte):** balancea por IP/puerto. Ej: HAProxy en modo tcp, NLB de AWS.
- **L7 (aplicación):** balancea por URL, cabeceras, cookies. Ej: nginx, HAProxy http, ALB de AWS.

### Health checks

El LB comprueba periódicamente la salud de cada backend (`GET /health`). Si falla, se retira del pool.

### Sticky sessions

El mismo cliente se enruta siempre al mismo backend (útil para sesiones en memoria), usando una cookie o hash de IP.

### High Availability

Un solo balanceador es un punto único de fallo. Para HA se usan dos con **VRRP** (IP virtual flotante) o servicios gestionados (AWS ALB, Cloudflare).

---

## Resumen

- **OSI** = marco teórico de 7 capas; **TCP/IP** = el modelo real de internet.
- **IP** identifica al host, **puerto** identifica al servicio, **DNS** resuelve nombres.
- **TCP** es fiable y orientado a conexión; **UDP** es rápido y sin conexión.
- **HTTP/HTTPS** es el protocolo de aplicación de la web, sobre TCP/TLS.
- **NAT** y **CIDR** hacen posible que IPv4 siga funcionando.
- **Firewalls** filtran tráfico; **VPN** crea túneles cifrados.
- **Load balancers** escalan horizontalmente y dan disponibilidad.

> Siguiente: [operating-systems.md](operating-systems.md)
