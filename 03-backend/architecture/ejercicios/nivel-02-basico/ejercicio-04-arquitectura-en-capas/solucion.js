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
