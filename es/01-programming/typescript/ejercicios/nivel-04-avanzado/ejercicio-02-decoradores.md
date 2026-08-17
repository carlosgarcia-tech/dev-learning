# Ejercicio 02 — Decoradores

- **Nivel:** 4/5
- **Tema:** decoradores de clase y método, `experimentalDecorators`, factories
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `decoradores.ts` que:

1. Defina un decorador de clase `selable(nombre: string)` (factory) que asigne `this.nombre` al prototipo o anote la clase (en el prototipo, como referencia).
2. Defina un decorador de método `log` que envuelva el método original y registre en consola la llamada con el nombre del método y los argumentos.
3. Defina la clase `Servicio` con una propiedad `nombre` y un método `procesar(texto: string): string` decorado con `@log`.
4. Aplique `@selable("MisServicio")` a la clase.
5. Instancie `Servicio`, llame a `procesar` dos veces y muestre que el log imprime cada llamada con sus argumentos.

Salida esperada (ejemplo):

```
[log] llamando a procesar con ["hola"]
[log] procesar devolvio: HOLA
[log] llamando a procesar con ["mundo"]
[log] procesar devolvio: MUNDO
Clase decorada: MisServicio
```

## Requisitos

- [ ] Escribir un decorador de clase como factory que recibe argumentos.
- [ ] Escribir un decorador de método que envuelve el original.
- [ ] Aplicar ambos decoradores con la sintaxis `@nombre`.
- [ ] Incluir el `tsconfig.json` (o comando) con `experimentalDecorators` y `target` ES2022.
- [ ] Ejecutarlo localmente con `npx tsc --experimentalDecorators --target ES2022 --outDir dist decoradores.ts` y luego `node dist/decoradores.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los decoradores **experimentales** requieren `--experimentalDecorators` en el comando o `"experimentalDecorators": true` en `tsconfig.json`.
- Decorador de método: recibe `(target, propertyKey, descriptor)` y puede reemplazar `descriptor.value`.
- Decorador de clase: recibe el constructor; para añadir una propiedad usa `target.prototype`.
- Al envolver con `function (this: unknown, ...args: unknown[])`, el decorador no necesita tipar demasiado, pero usa el tipo del método.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --experimentalDecorators --target ES2022 --outDir dist decoradores.ts && node dist/decoradores.js
function selable(nombre: string) {
  return function <T extends new (...args: never[]) => unknown>(constructor: T): T {
    Object.defineProperty(constructor.prototype, "nombreClase", {
      value: nombre,
      writable: true,
    });
    return constructor;
  };
}

function log(
  target: unknown,
  propertyKey: string | symbol,
  descriptor: PropertyDescriptor
): void {
  const original = descriptor.value;
  descriptor.value = function (this: unknown, ...args: unknown[]): unknown {
    console.log(`[log] llamando a ${propertyKey} con ${JSON.stringify(args)}`);
    const resultado = original.apply(this, args);
    console.log(`[log] ${propertyKey} devolvio: ${String(resultado)}`);
    return resultado;
  };
}

@selable("MisServicio")
class Servicio {
  nombre = "Servicio";

  @log
  procesar(texto: string): string {
    return texto.toUpperCase();
  }
}

const s = new Servicio();
s.procesar("hola");
s.procesar("mundo");

const etiqueta = (s as unknown as { nombreClase: string }).nombreClase;
console.log(`Clase decorada: ${etiqueta}`);
````

</details>