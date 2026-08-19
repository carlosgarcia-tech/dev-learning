# Ejercicio 03 — Traits

- **Nivel:** 3/5
- **Tema:** `trait`, `use`, composición de comportamiento
- **Tiempo estimado:** 30 min

## Enunciado

Completa el código en `index.php`:

1. **`Timestampable`** (trait): propiedad privada `$creadoEn` (string, por defecto `""`); métodos `marcarCreado(): void` (guarda la fecha con `date("Y-m-d H:i:s")`) y `creadoEn(): string`.
2. **`Loggable`** (trait): propiedad privada `$log` (array, por defecto `[]`); métodos `registrar(string $mensaje): void` (añade `"[<fecha>] <mensaje>"`) y `log(): array`.
3. **`Articulo`**: usa `Timestampable`; constructor con `titulo`.
4. **`Comentario`**: usa `Timestampable` y `Loggable`; método `contenido(): string`.

## Requisitos

- [ ] `Articulo` tiene los métodos del trait `Timestampable`.
- [ ] Tras `marcarCreado()`, `creadoEn()` no es `""` y coincide con el formato `YYYY-MM-DD HH:MM:SS`.
- [ ] `Comentario` combina `Timestampable` y `Loggable`.
- [ ] `registrar()` añade entradas a `log()` con la fecha.
- [ ] Los traits no se pueden instanciar.
- [ ] Los tests pasan: `php index_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `trait Timestampable { private string $creadoEn = ""; ... }`.
- Para usar el trait: `use Timestampable;` dentro de la clase.
- `date("Y-m-d H:i:s")` genera la fecha.
- En `Loggable`, `$this->log[] = "[{$fecha}] {$mensaje}";`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
trait Timestampable
{
    private string $creadoEn = "";

    public function marcarCreado(): void
    {
        $this->creadoEn = date("Y-m-d H:i:s");
    }

    public function creadoEn(): string
    {
        return $this->creadoEn;
    }
}

trait Loggable
{
    private array $log = [];

    public function registrar(string $mensaje): void
    {
        $this->log[] = "[" . date("Y-m-d H:i:s") . "] {$mensaje}";
    }

    public function log(): array
    {
        return $this->log;
    }
}

class Articulo
{
    use Timestampable;

    public function __construct(private string $titulo)
    {
    }

    public function titulo(): string
    {
        return $this->titulo;
    }
}

class Comentario
{
    use Timestampable;
    use Loggable;

    public function __construct(private string $contenido)
    {
    }

    public function contenido(): string
    {
        return $this->contenido;
    }
}
````

</details>