# Ejercicio 04 — HTTP/2 Multiplexing

- **Nivel:** 5/5
- **Tema:** HTTP/2, multiplexing y compresión de headers
- **Tiempo estimado:** 40 min

## Enunciado

Este ejercicio es teórico-práctico. Completa `respuesta.json` con las afirmaciones correctas sobre HTTP/2 y `test.sh` las validará.

Preguntas:

1. ¿Cuántas conexiones TCP usa HTTP/2 para múltiples peticiones paralelas? → `conexiones_tcp`
2. ¿Cómo se llaman las unidades de datos en HTTP/2? → `unidades_datos`
3. ¿Qué tecnología comprime los headers en HTTP/2? → `compresion_headers`
4. ¿Qué protocolo de transporte usa HTTP/2 en la práctica? → `transporte_practica`
5. ¿Resuelve HTTP/2 el head-of-line blocking de TCP? → `resuelve_hol_blocking`

## Requisitos

- [ ] `respuesta.json` es JSON válido
- [ ] `conexiones_tcp` es `1` (una sola conexión)
- [ ] `unidades_datos` menciona `frames`
- [ ] `compresion_headers` menciona `HPACK`
- [ ] `transporte_practica` menciona `TLS` (o `HTTPS`)
- [ ] `resuelve_hol_blocking` es `false` (HTTP/2 no lo resuelve a nivel TCP; sí HTTP/3)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- HTTP/2 multiplexa varios streams en **una sola conexión TCP**.
- Los datos viajan en **frames** binarios.
- La compresión de headers es **HPACK**.
- En la práctica, los navegadores solo usan HTTP/2 sobre **TLS**.
- HTTP/2 **no** resuelve el head-of-line blocking de TCP (lo resuelve HTTP/3 con QUIC).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "conexiones_tcp": "1",
  "unidades_datos": "frames binarios",
  "compresion_headers": "HPACK",
  "transporte_practica": "TLS",
  "resuelve_hol_blocking": false
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
