# Flujo de trabajo

> Cómo trabajar con opencode: prompts efectivos, gestión del contexto, archivos y sesiones.

## El bucle de trabajo

Trabajar con opencode sigue un bucle:

1. **Escribes un prompt** describiendo la tarea.
2. **El agente lee contexto** (archivos, comandos previos).
3. **Propone acciones** (editar archivos, ejecutar comandos).
4. **Tú apruebas** o rechazas cada acción.
5. **El agente ejecuta** y observa el resultado.
6. **Itera** hasta completar la tarea.

```
Prompt -> [Lee contexto] -> [Propone] -> [Aprobación] -> [Ejecuta] -> [Observa] -> ...
```

## Prompts efectivos

La calidad de la respuesta depende de la calidad del prompt.

### Buenas prácticas

| Haz | No hagas |
|-----|----------|
| Especifica archivos concretos | "arregla el código" |
| Describe el comportamiento esperado | "haz que funcione" |
| Indica el lenguaje/framework | Asumir que lo sabe |
| Da ejemplos de entrada/salida | "mejora esto" |
| Pide pasos si la tarea es grande | Pedir todo de golpe |

### Ejemplos

**Vago:**
```
> Arregla el bug del login.
```

**Mejor:**
```
> El login falla cuando el password tiene caracteres especiales.
> Lee src/auth.js y src/routes/login.js.
> El error aparece en la línea 45 de auth.js al escapar el password.
> Corrígelo y añade un test en tests/auth.test.js que cubra
> passwords con @, #, $ y %.
```

### Tareas comunes

| Tipo | Ejemplo de prompt |
|------|-------------------|
| Bug fix | "El test `should create user` falla porque `email` no se valida. Lee `src/user.js` y arréglalo." |
| Feature | "Añade un endpoint DELETE /api/users/:id en `src/routes/users.js` que borre el usuario y devuelva 204." |
| Refactor | "Extrae la lógica de validación de `src/auth.js` a `src/validators/auth.js` y exporta las funciones." |
| Test | "Añade tests para `src/utils/format.js` cubriendo casos borde (vacío, null, números negativos)." |
| Docs | "Genera un README.md para este paquete basándote en `package.json` y `src/index.js`." |
| Review | "Lee los cambios de git diff y dime si hay problemas de seguridad o rendimiento." |

## Contexto

El **contexto** es todo lo que el agente puede usar para razonar: archivos del repo, comandos ejecutados, salida de comandos y mensajes previos de la sesión.

### Cómo proporcionar contexto

1. **Referencias explícitas en el prompt:** "Lee `src/index.js`".
2. **Archivos abiertos:** si la TUI soporta selección de archivos activos.
3. **Comandos previos:** la salida de comandos ejecutados en la sesión.
4. **Símbolos:** "la función `calculateTotal`".

### Mantener el contexto relevante

- **Cierra sesiones largas:** si el contexto crece demasiado, el agente pierde foco. Empieza una sesión nueva para tareas distintas.
- **Sé explícito:** no asumas que recuerda de hace 50 mensajes.
- **Referencia archivos por ruta:** es más fiable que descripciones vagas.

### Límites del contexto

Cada modelo tiene una **ventana de contexto** (tokens). Si el proyecto es enorme, el agente no puede leerlo todo de golpe. Estrategias:

- Lee solo los archivos relevantes para la tarea.
- Usa herramientas de búsqueda (`grep`, `find`) para localizar.
- Resume resultados intermedios.

## Archivos

opencode puede leer y escribir archivos del proyecto.

### Leer

El agente puede leer archivos para entender el código antes de proponer cambios. Tú puedes pedirle que lea:

```
> Lee src/index.js, src/router.js y src/middleware.js y explícame cómo fluye una petición.
```

### Escribir

Cuando el agente quiere modificar un archivo, propone el cambio y **espera tu aprobación**. Según el modo de permisos:

- **Modo ask:** pide confirmación para cada escritura.
- **Modo auto:** aplica cambios automáticamente.
- **Modo yolo:** no pide confirmación para nada (peligroso).

### Diff

Los cambios se muestran como un **diff** para que veas exactamente qué se añade y qué se quita:

```diff
- function getUsers() {
-   return db.query('SELECT * FROM users');
- }
+ async function getUsers() {
+   return db.query('SELECT * FROM users WHERE active = true');
+ }
```

### Archivos nuevos

El agente puede crear archivos nuevos:

```
> Crea tests/utils.test.js con tests para las funciones de src/utils.js
```

## Sesiones

Una **sesión** es una conversación con memoria. El agente recuerda los prompts, archivos leídos, comandos y cambios de esa sesión.

### Iniciar sesión

```bash
opencode          # sesión nueva en el directorio actual
```

### Continuar una sesión

```bash
opencode session list           # ver sesiones pasadas
opencode session resume <id>    # continuar una sesión
```

### Cuándo cerrar una sesión

- Cuando la tarea está completa.
- Cuando cambias a una tarea distinta.
- Cuando el contexto está saturado y las respuestas degradan.

### Persistencia

Las sesiones se guardan en `.opencode/` dentro del proyecto. Puedes volver a una sesión anterior y seguir donde lo dejaste, incluso días después.

## Comandos durante la sesión

El agente puede ejecutar comandos en tu terminal:

- **Build:** `pnpm run build`
- **Tests:** `pnpm test`
- **Lint:** `pnpm run lint`
- **Git:** `git status`, `git diff`

La salida del comando se incorpora al contexto, y el agente la usa para iterar.

### Ejemplo de iteración

```
Tú: Arregla el test fallido de users.
Agente: (lee tests/users.test.js y src/users.js)
       Veo que falta manejar el caso de email vacío.
       Propuesta: añadir validación en src/users.js línea 23.
Tú: [aprueba]
Agente: (edita el archivo)
       Ejecuto los tests.
       [ejecuta pnpm test]
       Los tests pasan.
```

## Estrategias de uso

### Tarea pequeña, sesión corta

Para una tarea concreta (un bug, un test), una sesión corta y enfocada funciona mejor.

### Tarea grande, dividir

Para features grandes, divide en subtareas:

```
1. "Diseña la estructura de carpetas para el módulo de pagos."
2. "Crea el modelo de datos en src/models/payment.js."
3. "Implementa el endpoint POST /api/payments."
4. "Añade tests para el endpoint."
```

### Revisar antes de aceptar

- Lee el diff completo.
- Ejecuta los tests tú mismo si tienes duda.
- Comprueba que no se rompe nada más.

## Errores comunes

| Error | Solución |
|-------|----------|
| Prompt vago | Sé específico: archivos, líneas, comportamiento |
| Contexto saturado | Empieza sesión nueva |
| No revisar diffs | Lee siempre antes de aceptar |
| Confianza ciega | Verifica con tests |
| Pedir todo a la vez | Divide en pasos |

## Buenas prácticas

1. **Sé específico** en los prompts: archivos, funciones, comportamientos.
2. **Divide tareas grandes** en pasos manejables.
3. **Revisa siempre los diffs** antes de aceptar.
4. **Mantén sesiones enfocadas**: una tarea, una sesión.
5. **Pide al agente que explique** su razonamiento si no entiendes un cambio.
6. **Verifica con tests** los cambios importantes.

---

> Anterior: [Fundamentos](01-fundamentos.md) · Siguiente: [Configuración y personalización](03-configuracion-y-personalizacion.md)
