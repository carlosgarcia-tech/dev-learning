# Ejercicio 03 — Caché LRU

- **Nivel:** 5/5
- **Tema:** Implementar caché LRU
- **Tiempo estimado:** 35 min

## Enunciado

Crea un archivo `lru.js` que implemente una caché **LRU (Least Recently Used)**:

1. Clase `CachéLRU` con constructor que reciba `capacidad` (número máximo de elementos).
2. Método `obtener(clave)`:
   - Si la clave existe, muévela al "más reciente" y devuelve su valor.
   - Si no existe, devuelve `null`.
3. Método `poner(clave, valor)`:
   - Si la clave ya existe, actualiza el valor y márcala como la más reciente.
   - Si la caché está llena, elimina el elemento **menos recientemente usado** antes de insertar.
   - Añade el nuevo elemento como el más reciente.
4. Método `tamaño()` que devuelva cuántos elementos hay.
5. Implementación con `Map` (que preserva el orden de inserción) o con listas enlazadas.

Prueba:

```javascript
const cache = new CachéLRU(2);
cache.poner("a", 1);      // {a:1}
cache.poner("b", 2);      // {a:1, b:2}
cache.obtener("a");       // 1  -> ahora "a" es el más reciente
cache.poner("c", 3);      // llena -> expulsa "b" (el menos usado)
console.log(cache.obtener("a")); // 1
console.log(cache.obtener("b")); // null (fue expulsado)
console.log(cache.obtener("c")); // 3
console.log(cache.tamaño());     // 2
```

## Requisitos

- [ ] Respetar la política LRU: expulsar siempre el menos recientemente usado.
- [ ] `obtener` actualiza el orden de uso.
- [ ] `poner` sobre elementos existentes no duplica entradas.
- [ ] Ejecutarlo localmente con `node lru.js` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-03-cache-lru.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Con `Map`: `delete(clave)` y vuelve a `set(clave, valor)` para marcar como más reciente.
- Para saber el elemento más antiguo: `this.map.keys().next().value` (el primer insertado).
- Al llenar: `if (this.map.size === this.capacidad) this.map.delete(primerClave)`.
- `map.size` te da el número de elementos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
class CachéLRU {
  constructor(capacidad) {
    this.capacidad = capacidad;
    this.map = new Map();
  }

  obtener(clave) {
    if (!this.map.has(clave)) return null;
    const valor = this.map.get(clave);
    this.map.delete(clave);
    this.map.set(clave, valor);
    return valor;
  }

  poner(clave, valor) {
    if (this.map.has(clave)) {
      this.map.delete(clave);
    } else if (this.map.size === this.capacidad) {
      const masAntiguo = this.map.keys().next().value;
      this.map.delete(masAntiguo);
    }
    this.map.set(clave, valor);
  }

  tamaño() {
    return this.map.size;
  }
}

if (require.main === module) {
  const cache = new CachéLRU(2);
  cache.poner("a", 1);
  cache.poner("b", 2);
  cache.obtener("a");
  cache.poner("c", 3);
  console.log(cache.obtener("a")); // 1
  console.log(cache.obtener("b")); // null
  console.log(cache.obtener("c")); // 3
  console.log(cache.tamaño());     // 2
}

module.exports = { CachéLRU };
````

</details>