# Producción y buenas prácticas

> Mejores prácticas, patrones de uso, seguridad y troubleshooting con opencode.

## Mejores prácticas generales

### 1. Revisiones humanas obligatorias

opencode puede generar código correcto, pero **tú eres responsable** de lo que entra al repo.

- Lee siempre el diff antes de aceptar.
- Ejecuta los tests tras cambios importantes.
- No hagas `--yolo` en código de producción.

### 2. Commits pequeños y revisables

Si el agente hace un cambio enorme, divídelo en commits lógicos:

```bash
opencode run "Divide los cambios actuales en commits lógicos siguiendo conventional commits" --auto
```

### 3. Sigue el estilo del proyecto

```
> Antes de escribir código, lee .eslintrc.json, .prettierrc y 2-3 archivos
> existentes para entender el estilo del proyecto. Úsalo en tu código.
```

### 4. Pide explicaciones

Si no entiendes un cambio:

```
> Explícame por qué elegiste esta estructura y qué alternativas consideraste.
```

### 5. No delegues decisiones de arquitectura

opencode es bueno implementando, no decidiendo arquitectura sin contexto. Decide tú la estructura y deja que implemente.

## Patrones de uso

### Patrón: explorar antes de implementar

```
1. "Lee src/auth.js, src/middleware/auth.js y src/routes/login.js.
    Explícame cómo funciona el flujo de autenticación."
2. (revisas la explicación)
3. "Añade rate limiting al endpoint de login.
    Usa la librería express-rate-limit si está disponible."
```

Primero entiendes, luego implementas.

### Patrón: TDD con opencode

```
1. "Escribe tests (en rojo) para la función validateEmail en src/validators.js.
    Cubre: email válido, sin @, sin dominio, caracteres especiales."
2. (opencode crea los tests, fallan)
3. "Implementa validateEmail para que pasen todos los tests."
4. (opencode implementa)
5. "Refactoriza sin romper los tests."
```

### Patrón: revisión de PR

```
> Revisa los cambios de git diff main...HEAD.
> Para cada archivo:
> - Identifica bugs potenciales
> - Marca problemas de seguridad
> - Sugiere mejoras de rendimiento
> - Comprueba que hay tests
> Genera un informe en Markdown con secciones por archivo.
```

### Patrón: migración mecánica

```
> Vamos a renombrar la función `getUserData` por `fetchUser` en todo el proyecto.
> 1. Busca todas las ocurrencias con grep.
> 2. Renombra en cada archivo.
> 3. Actualiza los imports.
> 4. Ejecuta los tests para verificar.
```

### Patrón: documentación viva

```
> Lee src/api/users.js y genera文档 JSDoc para cada función exportada.
> Incluye @param, @returns y un ejemplo de uso.
```

## Seguridad

### Amenazas a considerar

| Riesgo | Descripción | Mitigación |
|--------|-------------|------------|
| Prompt injection | Input malicioso que engaña al agente | No procesar datos no confiables sin revisión |
| Acceso a secretos | El agente lee `.env` o claves | Añade `.env` a deny o usa permisos |
| Ejecución de comandos | El agente ejecuta comandos peligrosos | Mantén `bash` en modo `ask` |
| MCP malicioso | Un MCP server expone datos | Revisa qué hace cada MCP |
| Dependencia de outputs | Confianza ciega sin verificar | Revisa diffs y tests |

### Proteger secretos

```json
{
  "permissions": {
    "deny": [".env", ".env.*", "*.pem", "*.key", "secrets/*"]
  }
}
```

O añade a `.opencodeignore`:

```
# .opencodeignore
.env
.env.*
*.pem
*.key
secrets/
credentials/
```

### No ejecutar código no confiable

Si el agente lee contenido de internet (issues de GitHub, web), ese contenido podría contener instrucciones maliciosas. Trata los outputs como **no confiables** y revísalos.

### Permisos mínimos

- `edit: ask` por defecto.
- `bash: ask` por defecto.
- `webfetch: deny` si no lo necesitas.
- `mcp: ask` y solo los servers necesarios.

## Coste y eficiencia

### Elegir el modelo adecuado

| Tarea | Modelo |
|-------|--------|
| Bug simple, snippet | small (Haiku, mini) |
| Feature, refactor | medium (Sonnet, GPT-4o) |
| Arquitectura, razonamiento complejo | large (Opus, GPT-4) |

```json
{
  "model": "anthropic/claude-sonnet-4",
  "smallModel": "anthropic/claude-haiku-3"
}
```

### Reducir consumo

- **Contexto enfocado:** no adjuntes archivos innecesarios.
- **Sesiones cortas:** cierra sesiones largas que acumulan contexto.
- **smallModel para tareas ligeras:** títulos, resúmenes, clasificación.
- **Caché:** opencode cachea resultados de herramientas idénticas.

### Estimar coste

Cada interacción consume tokens (input + output). Los modelos grandes cuestan más por token. Monitoriza el uso en el dashboard del proveedor.

## Troubleshooting

### El agente no encuentra un archivo

**Causa:** el archivo está fuera del directorio de trabajo o en `.opencodeignore`.

**Solución:**
- Verifica que lanzas opencode desde la raíz del proyecto.
- Comprueba `.opencodeignore`.
- Referencia el archivo por ruta absoluta o relativa desde la raíz.

### El agente repite el mismo error

**Causa:** contexto saturado o el modelo entra en bucle.

**Solución:**
- Empieza una sesión nueva.
- Simplifica el prompt.
- Cambia de modelo.

### Los cambios no se aplican

**Causa:** modo de permisos restrictivo o conflicto con archivos no modificables.

**Solución:**
- Comprueba el modo: `/permissions edit ask`.
- Revisa si el archivo está en `deny`.
- Verifica permisos del filesystem.

### El agente es lento

**Causa:** contexto enorme o modelo grande para tarea simple.

**Solución:**
- Usa `smallModel` para tareas ligeras.
- Cierra sesiones largas.
- Reduce el contexto: lee solo lo necesario.

### Error de autenticación

**Causa:** token expirado o no configurado.

**Solución:**
```bash
opencode auth status
opencode auth login
```

### MCP server no funciona

**Causa:** comando mal configurado, dependencias faltantes o token ausente.

**Solución:**
```bash
opencode mcp list
# Ejecuta el comando del MCP manualmente para ver el error
npx -y @modelcontextprotocol/server-github
```

### Salida de comandos no aparece

**Causa:** el comando falló silenciosamente o la salida es muy grande.

**Solución:**
- Ejecuta el comando tú mismo en la terminal para ver el error.
- Redirige stderr a stdout: `comando 2>&1`.
- Limita la salida: `comando | head -50`.

## Antipatrones a evitar

### 1. Confianza ciega

```bash
# ❌ Mal
opencode run "Refactoriza todo el proyecto" --yolo

# ✅ Bien
opencode run "Refactoriza el módulo auth siguiendo estos pasos: ..." --auto
# Revisas el diff, ejecutas tests
```

### 2. Prompts vagos

```
# ❌ Mal
> Haz el código mejor.

# ✅ Bien
> Extrae la validación de email de src/auth.js a src/validators/email.js
> y exporta la función validateEmail. Actualiza los imports.
```

### 3. No verificar con tests

```
# ❌ Mal
> Cambia el algoritmo de hash a bcrypt.
# (no verificas)

# ✅ Bien
> Cambia el algoritmo de hash a bcrypt en src/auth.js.
> Ejecuta los tests de auth y asegúrate de que pasan.
> Si algún test necesita actualizarse, actualízalo.
```

### 4. Contexto innecesario

```
# ❌ Mal
> Lee todos los archivos del proyecto y dime cómo mejorar el login.

# ✅ Bien
> Lee src/auth.js y src/routes/login.js.
> Propón mejoras de seguridad al endpoint de login.
```

## Checklist de uso responsable

- [ ] Reviso los diffs antes de aceptar.
- [ ] Ejecuto los tests tras cambios importantes.
- [ ] No dejo secretos en archivos accesibles.
- [ ] Uso permisos restrictivos por defecto.
- [ ] Comitea la configuración (`opencode.json`) para el equipo.
- [ ] Documento los prompts reutilizables.
- [ ] Monitorizo el coste de tokens.
- [ ] Mantengo sesiones enfocadas y cortas.

---

> Anterior: [Automatización e integración](04-automatizacion-y-integracion.md) · Volver al [índice](README.md)
