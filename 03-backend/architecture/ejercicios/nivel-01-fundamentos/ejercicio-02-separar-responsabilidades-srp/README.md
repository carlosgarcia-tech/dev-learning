# Ejercicio 02 — Separar responsabilidades (SRP)

- **Nivel:** 1/5
- **Tema:** Single Responsibility Principle
- **Tiempo estimado:** 20 min

## Enunciado

Tienes una clase `Factura` que hace de todo: calcula el total, genera XML, guarda en BD y envía email. Esto viola el SRP (tiene varias razones para cambiar). Tu tarea es **separar** las responsabilidades en clases distintas.

El archivo `solucion.js` debe contener:

- `Factura` — solo datos del dominio y cálculo del total (regla de negocio).
- `FacturaRepository` — persistencia (simulada con un Map).
- `FacturaSerializer` — conversión a XML/JSON.
- `FacturaMailer` — envío de email (simulado).

Una clase de orquestación `FacturaService` coordina las cuatro sin mezclar lógica.

Pasos:

1. Examina `estructura.json` para ver las responsabilidades esperadas.
2. Implementa `solucion.js` con las 4 clases + el service.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `Factura` con método `total()` y SIN persistencia ni serialización
- [ ] `solucion.js` define `FacturaRepository` con método `save(factura)`
- [ ] `solucion.js` define `FacturaSerializer` con método `toXML(factura)`
- [ ] `solucion.js` define `FacturaMailer` con método `enviar(factura)`
- [ ] `solucion.js` define `FacturaService` que coordina (recibe las 4 dependencias por constructor)
- [ ] La clase `Factura` no contiene `INSERT`, `toXML` ni `enviar`
- [ ] `estructura.json` es JSON válido y lista las 4 responsabilidades
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Cada clase tiene **una sola razón para cambiar**:
  - `Factura`: si cambian las reglas de cálculo.
  - `FacturaRepository`: si cambia la BD.
  - `FacturaSerializer`: si cambia el formato de salida.
  - `FacturaMailer`: si cambia el sistema de email.
- `Factura` solo guarda items y calcula `total = sum(precio * cantidad)`.
- `FacturaService` recibe las 4 dependencias y orquesta: `factura.total()` → `repo.save` → `serializer.toXML` → `mailer.enviar`.
- `estructura.json` puede ser `{"responsabilidades": ["calculo", "persistencia", "serializacion", "email"]}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
// Dominio: solo cálculo (SRP - regla de negocio)
class Factura {
  constructor(items) { this.items = items; }  // items: [{precio, cantidad}]
  total() {
    return this.items.reduce((s, i) => s + i.precio * i.cantidad, 0);
  }
}

// Persistencia (SRP - datos)
class FacturaRepository {
  constructor() { this.db = new Map(); }
  save(factura) {
    const id = 'f-' + Math.random().toString(36).slice(2);
    this.db.set(id, factura);
    return id;
  }
}

// Serialización (SRP - presentación del formato)
class FacturaSerializer {
  toXML(factura) {
    const items = factura.items
      .map(i => `  <item precio="${i.precio}" cantidad="${i.cantidad}"/>`)
      .join('\n');
    return `<factura total="${factura.total()}">\n${items}\n</factura>`;
  }
}

// Email (SRP - comunicación)
class FacturaMailer {
  enviar(factura) {
    return `Enviando email con factura de total ${factura.total()}`;
  }
}

// Service: orquesta, sin lógica propia de cada responsabilidad
class FacturaService {
  constructor(factura, repo, serializer, mailer) {
    this.factura = factura;
    this.repo = repo;
    this.serializer = serializer;
    this.mailer = mailer;
  }
  procesar() {
    const total = this.factura.total();
    const id = this.repo.save(this.factura);
    const xml = this.serializer.toXML(this.factura);
    const mail = this.mailer.enviar(this.factura);
    return { id, total, xml, mail };
  }
}

module.exports = { Factura, FacturaRepository, FacturaSerializer, FacturaMailer, FacturaService };
```

`estructura.json`:

```json
{
  "responsabilidades": ["calculo", "persistencia", "serializacion", "email"],
  "clases": {
    "Factura": "calculo del total (dominio)",
    "FacturaRepository": "persistencia (datos)",
    "FacturaSerializer": "serializacion a XML (formato)",
    "FacturaMailer": "envio de email (comunicacion)",
    "FacturaService": "orquestacion (coordina las 4)"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
