# Ejercicio 04 — Escalabilidad horizontal (stateless + load balancer)

- **Nivel:** 5/5
- **Tema:** Escalado horizontal, stateless y balanceo de carga
- **Tiempo estimado:** 45 min

## Enunciado

Implementa un **load balancer** que reparta peticiones entre N instancias stateless, con dos algoritmos (round-robin y least-connections), y health checks que sacan de la rotación las instancias caídas.

El archivo `solucion.js` debe contener:

- Una clase `Instancia` con `handle(req)` (procesa), `health()` (devuelve ok/down) y un contador de conexiones activas.
- Un `LoadBalancer` con `add(instancia)`, `remove(instancia)`, `distribute(req, algoritmo)`.
- Algoritmos: `round-robin` (cíclico) y `least-connections` (al de menos carga).
- Si una instancia está caída (`health() === 'down'`), se salta.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `Instancia` con `handle`, `health`, contador de conexiones
- [ ] `solucion.js` define `LoadBalancer` con `add`, `remove`, `distribute`
- [ ] `distribute(req, 'round-robin')` reparte cíclicamente entre instancias up
- [ ] `distribute(req, 'least-connections')` elige al de menos conexiones
- [ ] Las instancias down se saltan
- [ ] Si no hay instancias up, lanza error
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Instancia` tiene `this.conexiones = 0`; en `handle`, suma 1, procesa, resta 1 (simula concurrencia).
- Round-robin: mantén un índice; cada `distribute` avanza al siguiente up.
- Least-connections: filtra up, elige el de `Math.min(conexiones)`.
- `health()` puede devolver `'down'` para simular una caída (setea `this.up = false`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
class Instancia {
  constructor(id) {
    this.id = id;
    this.conexiones = 0;
    this.up = true;
  }
  health() { return this.up ? 'up' : 'down'; }
  async handle(req) {
    this.conexiones++;
    try {
      return { handled_by: this.id, req };
    } finally {
      this.conexiones--;
    }
  }
  // Simula mantener conexiones activas (para test least-connections)
  async hold() { this.conexiones++; }
  release() { this.conexiones--; }
}

class LoadBalancer {
  constructor() {
    this.instancias = [];
    this._rr = 0;
  }
  add(inst) { this.instancias.push(inst); return this; }
  remove(inst) {
    this.instancias = this.instancias.filter(i => i !== inst);
    return this;
  }
  _ups() { return this.instancias.filter(i => i.health() === 'up'); }
  distribute(req, algoritmo = 'round-robin') {
    const ups = this._ups();
    if (ups.length === 0) throw new Error('no hay instancias disponibles');
    let elegida;
    if (algoritmo === 'least-connections') {
      elegida = ups.reduce((min, i) => i.conexiones < min.conexiones ? i : min, ups[0]);
    } else { // round-robin
      elegida = ups[this._rr % ups.length];
      this._rr = (this._rr + 1) % ups.length;
    }
    return elegida.handle(req);
  }
}

module.exports = { Instancia, LoadBalancer };
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
