# Ejercicio 06 — Dependency Injection básica

- **Nivel:** 1/5
- **Tema:** Inversión de dependencias e inyección por constructor
- **Tiempo estimado:** 25 min

## Enunciado

Tienes un `LoggerService` que crea internamente su propia dependencia (`new ConsoleLogger()`), lo que lo acopla y dificulta los tests. Tu tarea es **invertir la dependencia** (DIP): el logger debe recibir su dependencia por constructor, permitiendo inyectar distintas implementaciones (consola, memoria para tests).

El archivo `solucion.js` debe contener:

- Una clase base `Logger` con método `log(mensaje)`.
- `ConsoleLogger` y `MemoryLogger` (este último guarda en array, útil para tests).
- `LoggerService` que **recibe** el logger por constructor (no lo crea) y lo usa.
- Comprobar que se puede inyectar `MemoryLogger` y verificar lo logueado.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define la clase base abstracta `Logger` con método `log`
- [ ] `solucion.js` define `ConsoleLogger` y `MemoryLogger`
- [ ] `solucion.js` define `LoggerService` que recibe el logger por constructor
- [ ] `LoggerService` NO crea el logger con `new` (lo recibe inyectado)
- [ ] `MemoryLogger` guarda los mensajes en un array accesible
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sin DIP: `this.logger = new ConsoleLogger()` dentro del service.
- Con DIP: `this.logger = logger` donde `logger` viene por constructor.
- `MemoryLogger` mantiene `this.mensajes = []` y en `log` hace `push`.
- Así en un test puedes inyectar `MemoryLogger` y luego assert sobre `logger.mensajes`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
// Interfaz común
class Logger {
  log(mensaje) { throw new Error('no implementado'); }
}

// Implementación real (consola)
class ConsoleLogger extends Logger {
  log(mensaje) { console.log(mensaje); }
}

// Implementación para tests (memoria)
class MemoryLogger extends Logger {
  constructor() { super(); this.mensajes = []; }
  log(mensaje) { this.mensajes.push(mensaje); }
}

// Service: NO crea el logger, lo RECIBE (DIP)
class LoggerService {
  constructor(logger) {        // inyección por constructor
    this.logger = logger;
  }
  registrar(mensaje) {
    this.logger.log(mensaje);
  }
}

module.exports = { Logger, ConsoleLogger, MemoryLogger, LoggerService };
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
