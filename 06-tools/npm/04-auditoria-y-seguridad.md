# Auditoría y seguridad

> `npm audit`, `npm fund`, vulnerabilidades, overrides, SBOM y seguridad de la cadena de suministro.

## La cadena de suministro de npm

Tu proyecto depende de cientos de paquetes transitivos. Cada uno es código de terceros que se ejecuta con tus privilegios. Esto crea una **superficie de ataque**:

- **Vulnerabilidades conocidas** en dependencias.
- **Paquetes maliciosos** (typosquatting, dependency confusion).
- **Cuentas comprometidas** de mantenedores.
- **Scripts de instalación** (`postinstall`) que ejecutan código arbitrario.

## npm audit

`npm audit` escanea tu árbol de dependencias y compara las versiones instaladas con la **base de datos de avisos** del registro de npm.

```bash
npm audit                    # muestra vulnerabilidades
npm audit --json             # salida en JSON (para CI)
npm audit fix                # intenta actualizar a versiones seguras
npm audit fix --force         # aplica cambios mayores (¡cuidado!)
npm audit signatures          # verifica firmas de los paquetes
```

### Niveles de severidad

| Severidad | Significado |
|-----------|-------------|
| `critical` | Ejecución remota de código, acceso total |
| `high` | Acceso a datos o ejecución importante |
| `moderate` | Acceso limitado o en condiciones específicas |
| `low` | Impacto mínimo o teórico |

### Salida típica

```
# npm audit report

lodash  <=4.17.20
Severity: high
Prototype Pollution in lodash - https://github.com/advisories/GHSA-...
fix available via `npm audit fix`
```

### `npm audit fix`

- Intenta actualizar dependencias a versiones **no vulnerables** respetando el semver de `package.json`.
- `--force` puede subir a versiones **major**, rompiendo la API. Úsalo solo tras revisar.

## npm fund

Muchos paquetes de npm son mantenidos por voluntarios. `npm fund` lista los paquetes que aceptan financiamiento y cómo contribuir.

```bash
npm fund                  # lista paquetes que aceptan donaciones
npm fund <paquete>        # cómo financiar un paquete concreto
```

En `package.json`:

```json
{
  "funding": {
    "type": "individual",
    "url": "https://github.com/sponsors/usuario"
  }
}
```

## Overrides

A veces una vulnerabilidad está en una **dependencia transitiva** que no puedes cambiar directamente desde tu `package.json`. Los **overrides** permiten forzar una versión concreta de cualquier paquete del árbol.

```json
{
  "overrides": {
    "lodash": "^4.17.21",
    "express": {
      "qs": "6.11.0"
    },
    "event-stream": "$event-stream-puppet"
  }
}
```

- `"lodash": "^4.17.21"` fuerza esa versión de lodash en todo el árbol.
- La forma anidada `{ "express": { "qs": "..." } }` solo afecta a `qs` dentro de `express`.
- `"paquete": "$otro"` reemplaza un paquete por otro.

Tras añadir un override, ejecuta `npm install` para que reconstruya el árbol.

> Antes de npm 8.2, esto se hacía con `resolutions` (yarn) o parcheando manualmente. `overrides` es el estándar nativo de npm.

## Vulnerabilidades comunes

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| Prototype pollution | Modificar `Object.prototype` vía datos | CVE en lodash |
| Path traversal | Leer/escribir fuera del path esperado | `../../../etc/passwd` |
| Command injection | Ejectar comandos shell con input no saneado | `child_process.exec(userInput)` |
| ReDoS | RegExp que causan tiempo exponencial | ciertos patrones maliciosos |
| Supply chain attack | Paquete malicioso que suplanta a otro | `crossenv` vs `cross-env` |

## SBOM (Software Bill of Materials)

Un **SBOM** es una lista completa y estructurada de todos los componentes de tu software, incluidas las dependencias transitivas. Es cada vez más exigido por normativas y políticas empresariales.

```bash
npm sbom --sbom-format cyclonedx      # formato CycloneDX
npm sbom --sbom-format spdx           # formato SPDX
npm sbom --sbom-type application
```

El SBOM permite:

- Auditar qué versiones exactas hay en producción.
- Detectar rápidamente qué se ve afectado por un CVE nuevo.
- Cumplir normativas de seguridad y licencias.

## Seguridad de la cadena de suministro

### 1. Verificar procedencia (provenance)

npm soporta **provenance**, que vincula un paquete publicado con el commit y el workflow de CI que lo generó, firmado por Sigstore.

```bash
npm publish --provenance            # requiere publicar desde GitHub Actions
npm audit signatures                 # verifica que los paquetes tengan firma
```

### 2. Bloquear scripts de instalación

Los scripts `postinstall` de dependencias pueden ejecutar código arbitrario. Si no los necesitas, desactívalos:

```ini
# .npmrc
ignore-scripts=true
```

```bash
npm install --ignore-scripts
```

### 3. Usar lockfile

Comitea siempre `package-lock.json` y usa `npm ci` en producción y CI para instalar exactamente las versiones auditadas.

### 4. Pinning y versiones exactas

Para infraestructura crítica, fija versiones exactas (sin `^`) y actualiza de forma controlada:

```json
{
  "dependencies": {
    "express": "4.18.2"
  }
}
```

### 5. Two-factor authentication (2FA)

Activa 2FA en tu cuenta de npm, al menos para `auth-and-writes` (publicación).

### 6. Auditoría de nuevos paquetes

Antes de añadir una dependencia:

- Comprueba el número de descargas y mantenedores.
- Revisa el repo, issues recientes y última publicación.
- Busca el paquete en `https://socket.dev` o `https://snyk.io`.
- Evita paquetes sin actividad o con un solo mantenedor desconocido.

### 7. Dependency confusion

Ataque donde un atacante publica en el registry público un paquete con el mismo nombre que uno privado tuyo. Si tu CI busca primero en el público, puede instalar el malicioso.

Prevención:

- Usa scopes (`@miorg/...`) y configura el registry privado para ese scope.
- Añade `npmrc` con `@miorg:registry=...` para que ese scope vaya solo al privado.
- Publica tus paquetes privados también en el público como placeholder o marca el nombre como reservado.

### 8. Typosquatting

Paquetes con nombres parecidos a otros populares (`crossenv` vs `cross-env`). Prevención: copia y pega los nombres, no los escribas a mano; revisa antes de instalar.

## Comandos de seguridad útiles

```bash
npm audit                       # listar vulnerabilidades
npm audit fix                   # arreglar automáticamente
npm audit --omit=dev            # ignorar devDependencies (lo que va a prod)
npm ls <paquete>               # dónde está y qué versión
npm explain <paquete>           # por qué está instalado
npm dedupe                      # eliminar duplicados del árbol
npm sbom                        # generar SBOM
```

## Flujo de seguridad recomendado

1. **Antes de añadir una dependencia:** revisa autor, descargas, repo y issues.
2. **En el proyecto:** comitea `package-lock.json`, usa `npm ci`.
3. **En CI:** ejecuta `npm audit` y falla si hay `high` o `critical` sin fix.
4. **Al publicar:** genera SBOM, firma con `--provenance`.
5. **Periódicamente:** revisa `npm outdated` y `npm audit`, actualiza.
6. **Si hay un CVE:** usa `overrides` si la dependencia es transitiva y no se puede actualizar directamente.

---

> Anterior: [Publicación y scoping](03-publicacion-y-scoping.md) · Siguiente: [Monorepos y workspaces](05-monorepos-y-workspaces.md)
