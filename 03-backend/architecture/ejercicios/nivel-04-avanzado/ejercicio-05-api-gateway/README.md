# Ejercicio 05 — Implementar API Gateway

- **Nivel:** 4/5
- **Tema:** API Gateway (routing y agregación)
- **Tiempo estimado:** 40 min

## Enunciado

Implementa un **API Gateway** que enruta peticiones a distintos microservicios según el path, y que valida un token de auth antes de delegar.

El archivo `solucion.js` debe contener:

- Una clase `ApiGateway` con método `register(path, service)` y `request(path, token)`.
- `request(path, token)` valida el token (rechaza si no hay token → 401).
- Enruta al servicio registrado según el prefijo del path.
- Si no hay servicio para el path → 404.
- Si el token es válido y hay servicio → 200 con la respuesta del servicio.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `ApiGateway` con `register(path, service)` y `request(path, token)`
- [ ] Sin token → 401
- [ ] Path no registrado → 404
- [ ] Path registrado + token válido → 200 con respuesta del servicio
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `register(path, service)` guarda en un Map: `this.routes.set(path, service)`.
- `request(path, token)`: si `!token` → `{status:401}`.
- Busca el servicio cuyo prefijo coincide con el path; si ninguno → `{status:404}`.
- Si hay match → `service.handle(path)` → `{status:200, body}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
class ApiGateway {
  constructor() {
    this.routes = new Map();
  }
  register(prefix, service) {
    this.routes.set(prefix, service);
    return this;
  }
  request(path, token) {
    // Auth: sin token → 401
    if (!token) return { status: 401, body: { error: 'no autorizado' } };
    // Routing: busca el servicio cuyo prefijo coincide
    for (const [prefix, service] of this.routes) {
      if (path.startsWith(prefix)) {
        return { status: 200, body: service.handle(path) };
      }
    }
    // No match → 404
    return { status: 404, body: { error: 'ruta no encontrada' } };
  }
}

// Servicios simulados (microservicios detrás del gateway)
const userService = { handle: (path) => ({ servicio: 'users', path }) };
const productService = { handle: (path) => ({ servicio: 'products', path }) };

module.exports = { ApiGateway, userService, productService };
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
