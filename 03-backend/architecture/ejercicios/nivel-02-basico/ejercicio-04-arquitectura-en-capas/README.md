# Ejercicio 04 — Arquitectura en capas

- **Nivel:** 2/5
- **Tema:** Controller → Service → Repository
- **Tiempo estimado:** 35 min

## Enunciado

Implementa una **arquitectura en capas completa** para gestionar productos. Las tres capas deben estar separadas y comunicarse solo en una dirección (hacia abajo), con inyección de dependencias.

El archivo `solucion.js` debe contener:

- `ProductRepository` — datos (Map simulado), métodos `save`, `findById`, `findAll`.
- `ProductService` — negocio: valida que el precio sea positivo, crea producto, llama al repo.
- `ProductController` — presentación: parsea body, llama al service, devuelve `{status, body}`.
- Un punto de composición que cablea las tres capas.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.js` con las 3 capas y la composición.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `ProductRepository` con `save`, `findById`, `findAll`
- [ ] `solucion.js` define `ProductService` con `createProduct(name, precio)`
- [ ] `solucion.js` define `ProductController` con `postProduct(body)` y `getProducts()`
- [ ] `ProductService` valida que el precio sea > 0 (regla de negocio)
- [ ] `ProductController` NO contiene SQL ni reglas de negocio
- [ ] Las dependencias se inyectan por constructor (composición)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Controller recibe service por constructor; service recibe repo por constructor.
- `ProductService.createProduct` lanza Error si `precio <= 0`.
- Controller `postProduct({name, precio})` try/catch: ok → 201, error → 400.
- `getProducts()` devuelve `{status:200, body: [...]}`.
- Composición al final: `const controller = new ProductController(new ProductService(new ProductRepository()))`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
// ===== CAPA DE DATOS =====
class ProductRepository {
  constructor() { this.db = new Map(); }
  save(product) { this.db.set(product.id, product); return product; }
  findById(id) { return this.db.get(id); }
  findAll() { return [...this.db.values()]; }
}

// ===== CAPA DE NEGOCIO =====
class ProductService {
  constructor(repo) { this.repo = repo; }
  createProduct(name, precio) {
    if (precio <= 0) throw new Error('precio debe ser positivo');
    const product = { id: 'p-' + Date.now(), name, precio };
    return this.repo.save(product);
  }
  listProducts() { return this.repo.findAll(); }
}

// ===== CAPA DE PRESENTACIÓN =====
class ProductController {
  constructor(service) { this.service = service; }
  postProduct(body) {
    try {
      const p = this.service.createProduct(body.name, body.precio);
      return { status: 201, body: p };
    } catch (e) {
      return { status: 400, body: { error: e.message } };
    }
  }
  getProducts() {
    return { status: 200, body: this.service.listProducts() };
  }
}

// ===== COMPOSICIÓN =====
function createApp() {
  const repo = new ProductRepository();
  const service = new ProductService(repo);
  const controller = new ProductController(service);
  return { controller, service, repo };
}

module.exports = { ProductRepository, ProductService, ProductController, createApp };
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
