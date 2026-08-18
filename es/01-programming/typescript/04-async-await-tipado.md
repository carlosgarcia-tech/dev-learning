# 04 — Async/Await Tipado

## Objetivos

- [ ] Tipar `Promise<T>`
- [ ] Usar `async/await` con tipos explícitos
- [ ] Manejar errores en código asíncrono tipado
- [ ] Tipar `Promise.all`, `Promise.race` y `Promise.allSettled`

## Apuntes

### Promesas tipadas

```typescript
function esperar(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function obtenerUsuario(id: number): Promise<{ id: number; nombre: string }> {
    const respuesta = await fetch(`https://api.com/usuarios/${id}`);
    return respuesta.json();
}
```

### Manejo de errores

```typescript
async function obtenerDatosSeguro<T>(url: string): Promise<T | null> {
    try {
        const respuesta = await fetch(url);
        if (!respuesta.ok) {
            throw new Error(`HTTP ${respuesta.status}`);
        }
        return (await respuesta.json()) as T;
    } catch (error) {
        console.error("Error al obtener datos:", error);
        return null;
    }
}
```

### Promise.all / allSettled tipados

```typescript
async function obtenerVarios(ids: number[]): Promise<{ id: number; nombre: string }[]> {
    const promesas = ids.map(id => obtenerUsuario(id));
    return Promise.all(promesas);
}

async function obtenerVariosSeguro(ids: number[]) {
    const resultados = await Promise.allSettled(ids.map(id => obtenerUsuario(id)));
    return resultados.filter(
        (r): r is PromiseFulfilledResult<{ id: number; nombre: string }> => r.status === "fulfilled"
    ).map(r => r.value);
}
```

## Ejercicios Relacionados

- [Ejercicio 01: Async Tipado](./ejercicios/nivel-04-avanzado/ejercicio-01-async-tipado/)

## Recursos

- [TypeScript Handbook — Async/Await](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#async-await)
