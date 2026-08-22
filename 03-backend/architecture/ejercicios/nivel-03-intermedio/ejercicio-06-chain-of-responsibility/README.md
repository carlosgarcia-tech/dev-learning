# Ejercicio 06 — Implementar Chain of Responsibility

- **Nivel:** 3/5
- **Tema:** Patrón Chain of Responsibility (cadena de manejadores)
- **Tiempo estimado:** 35 min

## Enunciado

Implementa un pipeline de **middleware** con Chain of Responsibility: una petición pasa por una cadena de manejadores (auth → log → negocio) hasta que uno la procesa o llega al final.

El archivo `solucion.js` debe contener:

- Una clase base `Manejador` con `setNext(h)` y `manejar(req)`.
- Manejadores concretos `AuthHandler`, `LogHandler`, `NegocioHandler`.
- `AuthHandler` rechaza (devuelve 401) si no hay `req.token`; si no, pasa al siguiente.
- `LogHandler` imprime el path y pasa al siguiente.
- `NegocioHandler` devuelve 200 OK.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `Manejador` con `setNext(h)` y `manejar(req)`
- [ ] `solucion.js` define `AuthHandler`, `LogHandler`, `NegocioHandler`
- [ ] `AuthHandler` devuelve 401 si no hay `req.token`, si no pasa al siguiente
- [ ] `LogHandler` registra y pasa al siguiente
- [ ] `NegocioHandler` devuelve 200 OK
- [ ] La cadena se construye con `setNext` anidados
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Manejador` guarda `this.next = null`; `setNext(h)` asigna y devuelve `h` (para encadenar).
- `manejar(req)`: si `this.next`, delega `return this.next.manejar(req)`; si no, devuelve null.
- `AuthHandler.manejar`: si `!req.token` return `{status:401, body:'no autorizado'}`; si no `super.manejar(req)`.
- Construcción: `auth.setNext(log).setNext(biz)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
class Manejador {
  constructor() { this.next = null; }
  setNext(h) { this.next = h; return h; }
  manejar(req) {
    if (this.next) return this.next.manejar(req);
    return null;
  }
}

class AuthHandler extends Manejador {
  manejar(req) {
    if (!req.token) return { status: 401, body: 'no autorizado' };
    return super.manejar(req);  // pasa al siguiente
  }
}

class LogHandler extends Manejador {
  manejar(req) {
    console.log(`[log] ${req.path}`);
    return super.manejar(req);  // pasa al siguiente
  }
}

class NegocioHandler extends Manejador {
  manejar(req) {
    return { status: 200, body: 'OK' };
  }
}

module.exports = { Manejador, AuthHandler, LogHandler, NegocioHandler };
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
