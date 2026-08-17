# Ejercicio 06 — Enums

- **Nivel:** 2/5
- **Tema:** `enum`, campos, métodos, `values()`, `switch` con enum
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `DiaSemana.java` que:

1. Defina un `enum DiaSemana` con los 7 días: `LUNES` a `DOMINGO`.
2. Dé a cada constante un campo `esLaborable` (boolean) y un campo `nombreEspanol` (String).
3. Incluya un constructor y un método `esFinDeSemana()` que devuelva `!esLaborable`.
4. En `main`:
   - Recorra `DiaSemana.values()` e imprima: `LUNES es laborable` o `LUNES es fin de semana`.
   - Use un `switch` con `case LUNES -> ...` (sintaxis de flecha, Java 14+) para saludar según el día.

Salida esperada:

```
LUNES es laborable
MARTES es laborable
MIÉRCOLES es laborable
JUEVES es laborable
VIERNES es laborable
SÁBADO es fin de semana
DOMINGO es fin de semana
Saludo: Ánimo, toca currar.
```

## Requisitos

- [ ] El enum tiene campos, constructor y al menos un método propio.
- [ ] Recorrer todas las constantes con `values()`.
- [ ] Usar `switch` con la sintaxis de flecha (`->`) sobre el enum.
- [ ] Compilarlo localmente con `javac DiaSemana.java` y ejecutarlo con `java DiaSemana` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sintaxis: `LUNES(true, "Lunes"),` — el constructor del enum recibe los campos.
- `values()` devuelve un array con todas las constantes en orden de declaración.
- En el `switch` con flecha no hace falta `break`.
- Recuerda que el `switch` sobre enum usa los nombres en mayúsculas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class DiaSemana {
    enum Dia {
        LUNES(true, "Lunes"),
        MARTES(true, "Martes"),
        MIERCOLES(true, "Miércoles"),
        JUEVES(true, "Jueves"),
        VIERNES(true, "Viernes"),
        SABADO(false, "Sábado"),
        DOMINGO(false, "Domingo");

        private final boolean esLaborable;
        private final String nombreEspanol;

        Dia(boolean esLaborable, String nombreEspanol) {
            this.esLaborable = esLaborable;
            this.nombreEspanol = nombreEspanol;
        }

        public String nombreEspanol() {
            return nombreEspanol;
        }

        public boolean esFinDeSemana() {
            return !esLaborable;
        }
    }

    public static void main(String[] args) {
        for (Dia dia : Dia.values()) {
            String tipo = dia.esFinDeSemana() ? "fin de semana" : "laborable";
            System.out.println(dia + " es " + tipo);
        }

        Dia hoy = Dia.LUNES;
        String saludo = switch (hoy) {
            case SABADO, DOMINGO -> "¡Por fin, descanso!";
            case VIERNES -> "¡Ya casi es fin de semana!";
            default -> "Ánimo, toca currar.";
        };
        System.out.println("Saludo: " + saludo);
    }
}
````

</details>