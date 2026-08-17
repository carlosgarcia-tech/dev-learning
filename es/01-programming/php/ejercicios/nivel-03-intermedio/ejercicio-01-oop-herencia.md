# Ejercicio 01 — OOP: herencia

- **Nivel:** 3/5
- **Tema:** `extends`, `parent::`, `protected`, `abstract`, `final`, `instanceof`
- **Tiempo estimado:** 30 min

## Enunciado

Completa las clases en `ejercicio-01-oop-herencia.php`:

1. **`Vehiculo`** (base): constructor con `protected string $marca`; método `describir(): string` que devuelve `"Vehículo de marca <marca>"`.
2. **`Coche extends Vehiculo`**: sobreescribe `describir()` llamando a `parent::describir()` y añadiendo `" con 4 ruedas"`.
3. **`Moto extends Vehiculo`**: igual pero con `" con 2 ruedas"`.
4. **`Figura`** (abstracta): método abstracto `area(): float`.
5. **`Circulo extends Figura`**: `area()` devuelve `pi * radio²`.
6. **`Rectangulo extends Figura`**: `area()` devuelve `base * altura`.

## Requisitos

- [ ] `new Coche("Toyota")` es instancia de `Vehiculo` y de `Coche`.
- [ ] `$coche->describir()` es `"Vehículo de marca Toyota con 4 ruedas"`.
- [ ] `new Moto("Honda")->describir()` termina en `"con 2 ruedas"`.
- [ ] `(new Circulo(1))->area()` es `3.14` (redondeado); `(new Rectangulo(4, 3))->area()` es `12`.
- [ ] `Figura` no se puede instanciar (clase abstracta).
- [ ] Los tests pasan: `php ejercicio-01-oop-herencia_test.php`.

> **Nota:** PHP no está instalado en este entorno de aprendizaje. Ejecuta el comando localmente con PHP 8 o superior.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `protected` permite que las subclases accedan a la propiedad `$this->marca`.
- `parent::describir()` llama al método de la clase base.
- `abstract class Figura { abstract public function area(): float; }` y las subclases implementan `area()`.
- `round(pi() * $radio ** 2, 2)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````php
class Vehiculo
{
    public function __construct(protected string $marca)
    {
    }

    public function describir(): string
    {
        return "Vehículo de marca {$this->marca}";
    }
}

class Coche extends Vehiculo
{
    public function describir(): string
    {
        return parent::describir() . " con 4 ruedas";
    }
}

class Moto extends Vehiculo
{
    public function describir(): string
    {
        return parent::describir() . " con 2 ruedas";
    }
}

abstract class Figura
{
    abstract public function area(): float;
}

class Circulo extends Figura
{
    public function __construct(private float $radio)
    {
    }

    public function area(): float
    {
        return round(pi() * $this->radio ** 2, 2);
    }
}

class Rectangulo extends Figura
{
    public function __construct(private float $base, private float $altura)
    {
    }

    public function area(): float
    {
        return $this->base * $this->altura;
    }
}
````

</details>