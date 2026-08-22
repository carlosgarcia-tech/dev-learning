# Ejercicio 04 — Header Content-Type

- **Nivel:** 1/5
- **Tema:** Headers: Content-Type y MIME types
- **Tiempo estimado:** 15 min

## Enunciado

El header `Content-Type` indica el tipo de contenido del body. Completa `respuesta.json` asignando el `Content-Type` correcto a cada tipo de contenido.

Escenarios:

1. Una respuesta JSON de una API.
2. Una página HTML.
3. Una imagen PNG.
4. Datos de un formulario HTML clásico (campos `name=value`).
5. Una subida de archivo con campos y un archivo.
6. Texto plano.
7. Un binario genérico (descarga).
8. Un documento XML.

Escribe un objeto `tipos` que mapea cada clave al MIME type completo (con `charset=utf-8` cuando aplique).

## Requisitos

- [ ] `respuesta.json` es JSON válido con un objeto `tipos`
- [ ] JSON usa `application/json`
- [ ] HTML usa `text/html`
- [ ] PNG usa `image/png`
- [ ] Formulario clásico usa `application/x-www-form-urlencoded`
- [ ] Subida de archivos usa `multipart/form-data`
- [ ] Texto plano usa `text/plain`
- [ ] Binario genérico usa `application/octet-stream`
- [ ] XML usa `application/xml`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El formato es `tipo/subtipo`, opcionalmente seguido de `; charset=...`.
- Las APIs modernas usan `application/json`.
- El navegador sabe renderizar HTML cuando ve `text/html`.
- Los formularios normales (sin archivos) envían `application/x-www-form-urlencoded`.
- Si un formulario sube un archivo, usa `multipart/form-data` con un boundary.
- `application/octet-stream` es el “no sé qué es, descárgalo”.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "tipos": {
    "json_api": "application/json; charset=utf-8",
    "pagina_html": "text/html; charset=utf-8",
    "imagen_png": "image/png",
    "formulario_clasico": "application/x-www-form-urlencoded",
    "subida_archivo": "multipart/form-data",
    "texto_plano": "text/plain; charset=utf-8",
    "binario_generico": "application/octet-stream",
    "documento_xml": "application/xml; charset=utf-8"
  }
}
```

Ejemplo de respuesta real:

```http
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Content-Length: 27

{"mensaje": "Hola"}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
