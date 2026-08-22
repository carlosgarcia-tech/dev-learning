# 02 — Formularios y multimedia

> Form elements (input types, select, textarea, button), validación HTML5, audio, video, canvas, iframe, embed.

## Objetivos

- [ ] Construir formularios completos con todos sus elementos
- [ ] Conocer todos los `type` de `<input>` de HTML5
- [ ] Usar `<select>`, `<textarea>` y `<button>` correctamente
- [ ] Aplicar validación nativa de HTML5
- [ ] Insertar audio y video con controles
- [ ] Dibujar en un `<canvas>` con JavaScript
- [ ] Incrustar contenido externo con `<iframe>` de forma segura
- [ ] Agrupar campos con `<fieldset>` y `<legend>`

## El elemento `<form>`

El contenedor de todos los campos. Define a dónde y cómo se envían los datos.

```html
<form action="/api/registro" method="POST" enctype="application/x-www-form-urlencoded">
  <!-- campos aquí -->
</form>
```

| Atributo | Descripción |
|---|---|
| `action` | URL que procesa el formulario |
| `method` | `GET` (visible en URL) o `POST` (cuerpo) |
| `enctype` | Codificación: `urlencoded`, `multipart/form-data` (archivos), `text/plain` |
| `target` | Dónde mostrar la respuesta |
| `novalidate` | Desactiva la validación nativa |
| `autocomplete` | `on`/`off` para autocompletar del navegador |

> `GET` envía los datos en la URL (visible, limitado en tamaño, sirve para búsquedas/filtros). `POST` los envía en el cuerpo (más seguro, sin límite, para datos sensibles).

## `<label>`

Asocia un texto descriptivo a un campo. Es **clave para accesibilidad** y aumenta la zona clicable.

```html
<!-- Recomendado: asociación explícita con for/id -->
<label for="email">Correo electrónico</label>
<input type="email" id="email" name="email">

<!-- Alternativa: envolver el campo -->
<label>
  Correo electrónico
  <input type="email" name="email">
</label>
```

## Tipos de `<input>`

HTML5 introduce muchos `type` que activan teclados específicos en móvil y validación nativa.

```html
<input type="text" name="nombre">
<input type="email" name="email">
<input type="password" name="clave">
<input type="number" name="edad" min="0" max="120">
<input type="tel" name="telefono">
<input type="url" name="web">
<input type="search" name="busqueda">
<input type="date" name="nacimiento">
<input type="time" name="hora">
<input type="datetime-local" name="fecha_hora">
<input type="month" name="mes">
<input type="week" name="semana">
<input type="color" name="color_favorito">
<input type="range" name="volumen" min="0" max="100" step="10">
<input type="file" name="avatar" accept="image/*">
<input type="checkbox" name="acepto">
<input type="radio" name="plan" value="basico">
<input type="hidden" name="token" value="abc123">
<input type="submit" value="Enviar">
<input type="reset" value="Limpiar">
<input type="button" value="Botón">
```

### Tabla de tipos de input

| `type` | Uso | Validación nativa |
|---|---|---|
| `text` | Texto genérico | — |
| `email` | Correo | Formato de email |
| `password` | Contraseña (oculta) | — |
| `number` | Números | Solo dígitos, `min`/`max`/`step` |
| `tel` | Teléfono | — (patrón manual) |
| `url` | URL | Formato URL |
| `search` | Búsqueda | — |
| `date` | Fecha | Formato fecha |
| `time` | Hora | Formato hora |
| `datetime-local` | Fecha y hora | — |
| `color` | Selector de color | Hex |
| `range` | Deslizador | Rango |
| `file` | Archivo | `accept` |
| `checkbox` | Casilla (multi) | — |
| `radio` | Opción única | Agrupados por `name` |
| `hidden` | Dato oculto | — |
| `submit`/`reset`/`button` | Botones | — |

## Atributos de validación

| Atributo | Descripción |
|---|---|
| `required` | Campo obligatorio |
| `min` / `max` | Valor mínimo/máximo (number, date) |
| `minlength` / `maxlength` | Longitud de texto |
| `pattern` | Expresión regular |
| `step` | Incremento permitido |
| `type="email"` | Valida formato email |
| `type="url"` | Valida formato URL |

```html
<input
  type="text"
  name="usuario"
  required
  minlength="3"
  maxlength="20"
  pattern="[a-zA-Z0-9_]+"
  title="Solo letras, números y guion bajo"
>
```

## `<select>` y `<option>`

Lista desplegable de opciones.

```html
<label for="pais">País:</label>
<select name="pais" id="pais" required>
  <option value="" disabled selected>Elige un país</option>
  <option value="es">España</option>
  <option value="mx">México</option>
  <option value="ar">Argentina</option>
  <optgroup label="Europa">
    <option value="fr">Francia</option>
    <option value="de">Alemania</option>
  </optgroup>
</select>
```

- `multiple` permite seleccionar varias opciones.
- `size` muestra varias opciones a la vez.
- `<optgroup label="...">` agrupa opciones.

## `<textarea>`

Texto multilínea. A diferencia de `<input>`, el contenido va entre las etiquetas.

```html
<label for="bio">Biografía:</label>
<textarea name="bio" id="bio" rows="5" cols="40" maxlength="500"
  placeholder="Cuéntanos sobre ti..."></textarea>
```

| Atributo | Descripción |
|---|---|
| `rows` / `cols` | Tamaño visible |
| `maxlength` / `minlength` | Longitud |
| `placeholder` | Texto de ayuda |
| `wrap` | `soft`/`hard` al enviar |

## `<button>`

```html
<button type="submit">Enviar</button>
<button type="reset">Limpiar</button>
<button type="button">Acción JS</button>
```

> **Errores**: un `<button>` sin `type` dentro de un `<form>` es `submit` por defecto y puede enviar el formulario sin querer. Si solo quieres una acción JS, usa `type="button"`.

## Agrupación: `<fieldset>` y `<legend>`

```html
<form>
  <fieldset>
    <legend>Datos personales</legend>
    <label for="nombre">Nombre</label>
    <input type="text" id="nombre" name="nombre" required>
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>
  </fieldset>

  <fieldset>
    <legend>Dirección</legend>
    <label for="calle">Calle</label>
    <input type="text" id="calle" name="calle">
  </fieldset>

  <button type="submit">Enviar</button>
</form>
```

## Radios y checkboxes

```html
<fieldset>
  <legend>Plan</legend>
  <label><input type="radio" name="plan" value="basico" checked> Básico</label>
  <label><input type="radio" name="plan" value="pro"> Pro</label>
  <label><input type="radio" name="plan" value="empresa"> Empresa</label>
</fieldset>

<fieldset>
  <legend>Intereses</legend>
  <label><input type="checkbox" name="intereses" value="deportes"> Deportes</label>
  <label><input type="checkbox" name="intereses" value="musica"> Música</label>
  <label><input type="checkbox" name="intereses" value="lectura"> Lectura</label>
</fieldset>
```

- Los **radios** comparten `name`: solo uno seleccionado.
- Los **checkboxes** permiten varias selecciones.

## Validación HTML5

El navegador valida antes de enviar si los campos cumplen las restricciones.

```html
<form action="/registro" method="POST">
  <label for="email">Email *</label>
  <input type="email" id="email" name="email" required>

  <label for="edad">Edad</label>
  <input type="number" id="edad" name="edad" min="18" max="99">

  <label for="web">Sitio web</label>
  <input type="url" id="web" name="web">

  <label for="cp">Código postal</label>
  <input type="text" id="cp" name="cp" pattern="[0-9]{5}" title="5 dígitos">

  <button type="submit">Registrarse</button>
</form>
```

### Atributos de validación

| Atributo | Ejemplo | Qué valida |
|---|---|---|
| `required` | `required` | No vacío |
| `type="email"` | — | Sintaxis de email |
| `type="url"` | — | Sintaxis de URL |
| `min`/`max` | `min="0" max="100"` | Rango numérico o fecha |
| `minlength`/`maxlength` | `minlength="8"` | Longitud de texto |
| `pattern` | `pattern="[0-9]{5}"` | Expresión regular |
| `step` | `step="0.01"` | Incremento válido |

```html
<!-- La validación nativa se desactiva con novalidate -->
<form novalidate>...</form>
```

## Audio

```html
<audio controls>
  <source src="cancion.mp3" type="audio/mpeg">
  <source src="cancion.ogg" type="audio/ogg">
  Tu navegador no soporta audio.
</audio>
```

| Atributo | Descripción |
|---|---|
| `controls` | Muestra controles |
| `autoplay` | Reproduce al cargar (molesto, a menudo bloqueado) |
| `loop` | Repite en bucle |
| `muted` | Silenciado |
| `preload` | `auto`/`metadata`/`none` |

## Video

```html
<video controls width="640" poster="portada.jpg">
  <source src="video.mp4" type="video/mp4">
  <source src="video.webm" type="video/webm">
  <track kind="subtitles" src="subs.es.vtt" srclang="es" label="Español">
  Tu navegador no soporta video.
</video>
```

- `poster`: imagen previa antes de reproducir.
- `width`/`height`: dimensiones.
- `<track>`: subtítulos y descripciones (accesibilidad).

## Canvas

Un lienzo para dibujar con JavaScript mediante la API 2D o WebGL.

```html
<canvas id="lienzo" width="400" height="300">
  Tu navegador no soporta canvas.
</canvas>

<script>
  const canvas = document.getElementById('lienzo');
  const ctx = canvas.getContext('2d');

  // Rectángulo
  ctx.fillStyle = '#3b82f6';
  ctx.fillRect(50, 50, 100, 80);

  // Círculo
  ctx.beginPath();
  ctx.arc(250, 150, 40, 0, Math.PI * 2);
  ctx.fillStyle = '#ef4444';
  ctx.fill();

  // Texto
  ctx.fillStyle = '#000';
  ctx.font = '20px sans-serif';
  ctx.fillText('Hola canvas', 120, 30);
</script>
```

| Método | Descripción |
|---|---|
| `fillRect(x,y,w,h)` | Rectángulo relleno |
| `strokeRect(x,y,w,h)` | Rectángulo con borde |
| `clearRect(x,y,w,h)` | Borra un área |
| `arc(x,y,r,ini,fin)` | Arco/círculo |
| `fillText(texto,x,y)` | Texto relleno |
| `moveTo`/`lineTo` | Trazar líneas |
| `beginPath`/`closePath` | Abrir/cerrar trazo |

## `<iframe>`

Incrusta otra página dentro de la actual.

```html
<iframe
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  width="560"
  height="315"
  title="Video de YouTube"
  loading="lazy"
  allow="accelerometer; autoplay; encrypted-media"
  allowfullscreen>
</iframe>
```

### Seguridad con iframes

| Atributo | Descripción |
|---|---|
| `sandbox` | Restringe lo que puede hacer el iframe |
| `allow` | Permite APIs concretas |
| `referrerpolicy` | Controla el referer |

```html
<iframe src="widget.html" sandbox="allow-scripts allow-same-origin"></iframe>
```

> **Aviso**: incrustar iframes de terceros sin `sandbox` es un riesgo. Usa siempre `sandbox` cuando sea posible.

## `<embed>`, `<object>` y `<picture>`

```html
<!-- embed: contenido externo genérico -->
<embed src="documento.pdf" type="application/pdf" width="600" height="400">

<!-- object: alternativa a embed con fallback -->
<object data="documento.pdf" type="application/pdf" width="600" height="400">
  <p>No se puede mostrar el PDF. <a href="documento.pdf">Descárgalo</a>.</p>
</object>

<!-- picture: imágenes responsivas por formato/tamaño -->
<picture>
  <source srcset="logo.avif" type="image/avif">
  <source srcset="logo.webp" type="image/webp">
  <img src="logo.jpg" alt="Logo">
</picture>
```

## Autocompletar

El atributo `autocomplete` sugiere valores guardados por el navegador. Usa los valores estandarizados para que funcione bien.

```html
<input type="text" name="nombre" autocomplete="name">
<input type="email" name="email" autocomplete="email">
<input type="tel" name="telefono" autocomplete="tel">
<input type="text" name="cp" autocomplete="postal-code">
<input type="text" name="direccion" autocomplete="street-address">
```

| Valor | Campo |
|---|---|
| `name` | Nombre completo |
| `given-name` / `family-name` | Nombre / apellidos |
| `email` | Correo |
| `tel` | Teléfono |
| `street-address` | Dirección |
| `postal-code` | Código postal |
| `country-name` | País |
| `username` / `new-password` / `current-password` | Login |

## Datalist: sugerencias

Lista de valores sugeridos sin limitar a una lista fija (a diferencia de `<select>`).

```html
<label for="navegador">Navegador:</label>
<input list="navegadores" id="navegador" name="navegador">
<datalist id="navegadores">
  <option value="Chrome">
  <option value="Firefox">
  <option value="Safari">
  <option value="Edge">
</datalist>
```

## `<output>` y `<progress>`

```html
<form oninput="resultado.value = parseInt(a.value) + parseInt(b.value)">
  <input type="number" id="a" value="10"> +
  <input type="number" id="b" value="20"> =
  <output name="resultado" for="a b">30</output>
</form>

<progress value="70" max="100">70%</progress>
<meter value="0.6" min="0" max="1" low="0.3" high="0.7" optimum="0.5">60%</meter>
```

## Conceptos clave

- El `<form>` define `action` y `method`; los campos se identifican con `name`.
- `type` de input activa teclados correctos y validación nativa en móvil.
- La validación HTML5 es **cliente**, nunca sustituye la validación en el servidor.
- `<label for>` es esencial para accesibilidad y usabilidad.
- `enctype="multipart/form-data"` es obligatorio para subir archivos.
- `<canvas>` es una superficie de dibujo controlada por JavaScript.
- Los iframes de terceros deben llevar `sandbox` y `title`.

## Errores comunes

- **`<button>` sin `type`** dentro de un formulario: se comporta como `submit` y recarga la página.
- **Olvidar `name`** en los campos: el dato no se envía al servidor.
- **Confundir radios y checkboxes**: radios comparten `name`, checkboxes no.
- **No usar `enctype`** al subir archivos: los datos no llegan bien.
- **`<label>` sin `for`**: el campo no se asocia y pierde accesibilidad.
- **Validar solo en cliente**: el usuario puede saltarse el HTML; valida también en servidor.
- **Iframes sin `sandbox`**: riesgo de seguridad si el contenido no es de confianza.
- **Olvidar `<track>`** en videos: se pierden subtítulos y accesibilidad.
- **`autoplay` sin `muted`**: los navegadores lo bloquean (molesta al usuario).
- **Poner `placeholder` como si fuera un `<label>`**: el placeholder desaparece al escribir.
