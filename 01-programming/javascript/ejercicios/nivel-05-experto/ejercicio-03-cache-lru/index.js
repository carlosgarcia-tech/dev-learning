class CachéLRU {
  constructor(capacidad) {
    // TODO: guarda capacidad y this.map = new Map().
    throw new Error("TODO: implementar el constructor de CachéLRU");
  }

  obtener(clave) {
    // TODO: si existe, muévela a "más reciente" y devuelve el valor; si no, null.
    throw new Error("TODO: implementar obtener(clave)");
  }

  poner(clave, valor) {
    // TODO: actualiza/inserta; si está llena, expulsa el menos reciente.
    throw new Error("TODO: implementar poner(clave, valor)");
  }

  tamaño() {
    // TODO: devuelve el número de elementos.
    throw new Error("TODO: implementar tamaño()");
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
