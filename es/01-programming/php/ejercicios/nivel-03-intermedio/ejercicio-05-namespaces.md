# Ejercicio 05 — Namespaces

- **Nivel:** 3/5
- **Tema:** `namespace`, `use`, alias y nombres completos (`\App\...`)
- **Tiempo estimado:** 25 min

## Enunciado

Completa las funciones en `ejercicio-05-namespaces.php` (declaradas en el namespace `App\Ejercicios`):

1. `rutaCompleta(string $clase)`: devuelve `"App\Ejercicios\<clase>"`.
2. `instanciar(string $fqn)`: devuelve `new $fqn()` para el nombre completo que recibe.
3. `importarComo(string $fqn)`: devuelve la última parte del nombre (lo que quedaría como alias en `use X\Y\Z as <alias>`).

El archivo de tests declara sus propias clases en `namespace App\Pruebas` y las invoca de forma totalmente calificada.

## Requisitos

- [ ] `rutaCompleta("Usuario")` es `"App\Ejercicios\Usuario"`.
- [ ] `importarComo("App\Pruebas\Usuario")` es `"Usuario"`.
- [ ] `instanciar("App\Pruebas\Usuario")` crea la clase de pruebas correcta.
- [ ] `instanciar("App\Pruebas\Nodo")` crea la segunda clase de pruebas.
- [ ] Los tests pasan: `php ejercicio-05-namespaces_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Al principio del archivo: `namespace App\Ejercicios;`.
- `new $fqn()` funciona si `$fqn` es un nombre completo como `"App\Pruebas\Usuario"`.
- Para la última parte usa `substr($fqn, strrpos($fqn, '\\') + 1)`.
- El tests llama a las funciones con `\App\Ejercicios\` para no colisionar con su propio namespace.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
namespace App\Ejercicios;

function rutaCompleta(string $clase): string
{
    return "App\\Ejercicios\\" . $clase;
}

function instanciar(string $fqn): object
{
    return new $fqn();
}

function importarComo(string $fqn): string
{
    $posicion = strrpos($fqn, '\\');
    return $posicion === false ? $fqn : substr($fqn, $posicion + 1);
}
````

</details>