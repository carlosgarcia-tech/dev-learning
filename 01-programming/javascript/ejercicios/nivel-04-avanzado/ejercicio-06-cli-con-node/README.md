# Ejercicio 06 — CLI con Node

- **Nivel:** 4/5
- **Tema:** process.argv, scripts de línea de comandos
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `cli.js` que sea un mini programa de consola:

1. Lea los argumentos con `process.argv`. Recuerda que los índices 0 y 1 son `node` y la ruta del script; los argumentos del usuario empiezan en el índice 2.
2. Si no se pasa ningún argumento (además de los dos de Node), imprima `"Uso: node cli.js <comando> <numero>"`.
3. Acepte los comandos:
   - `suma <n1> <n2>` → imprime la suma.
   - `resta <n1> <n2>` → imprime la resta.
   - `factorial <n>` → imprime el factorial con recursión.
   - cualquier otro → imprime `"Comando desconocido: <comando>"`.
4. Convierta los argumentos numéricos con `Number()` y valide que sean números (si `Number.isNaN`, imprime `"Argumento inválido"`).

Ejemplos de uso y salida:

```
$ node cli.js suma 4 5
9
$ node cli.js resta 10 4
6
$ node cli.js factorial 5
120
$ node cli.js
Uso: node cli.js <comando> <numero>
$ node cli.js foo 1
Comando desconocido: foo
```

## Requisitos

- [ ] Usar `process.argv` para leer argumentos.
- [ ] Implementar al menos 3 comandos.
- [ ] Validar que los números sean válidos con `Number.isNaN`.
- [ ] Ejecutarlo localmente con `node cli.js <comando> <n>` y verificar la salida.
- [ ] Los tests pasan: `node --test ejercicio-06-cli-con-node.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `const args = process.argv.slice(2);` te deja solo los argumentos del usuario.
- El comando es `args[0]` y los números `args[1]`, `args[2]`.
- Factorial recursivo: `if (n <= 1) return 1; return n * factorial(n - 1);`.
- Para salir con error: `process.exit(1)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
function sumar(a, b) {
  return a + b;
}

function restar(a, b) {
  return a - b;
}

function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

function procesarComando(args) {
  if (args.length === 0) {
    return "Uso: node cli.js <comando> <numero>";
  }

  const [comando, a, b] = args;

  switch (comando) {
    case "suma": {
      const n1 = Number(a);
      const n2 = Number(b);
      if (Number.isNaN(n1) || Number.isNaN(n2)) {
        return "Argumento inválido";
      }
      return String(sumar(n1, n2));
    }
    case "resta": {
      const n1 = Number(a);
      const n2 = Number(b);
      if (Number.isNaN(n1) || Number.isNaN(n2)) {
        return "Argumento inválido";
      }
      return String(restar(n1, n2));
    }
    case "factorial": {
      const n = Number(a);
      if (Number.isNaN(n) || n < 0) {
        return "Argumento inválido";
      }
      return String(factorial(n));
    }
    default:
      return `Comando desconocido: ${comando}`;
  }
}

if (require.main === module) {
  console.log(procesarComando(process.argv.slice(2)));
}

module.exports = { sumar, restar, factorial, procesarComando };
````

</details>