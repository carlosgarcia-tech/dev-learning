# Ejercicio 06 — Comparación timing-safe

- **Nivel:** 1/5
- **Tema:** Prevención de timing attacks en verificación de tokens
- **Tiempo estimado:** 20 min

## Enunciado

Un **timing attack** mide el tiempo que tarda una comparación de strings para adivinar caracteres secretos. La comparación normal (`==`) devuelve `false` en cuanto encuentra una diferencia, tardando más o menos según cuántos caracteres coincidan. La solución es usar **comparación de tiempo constante**.

En este ejercicio vas a comparar dos tokens de sesión y entender la diferencia entre una comparación vulnerable y una segura. Completa `comparacion.json` indicando qué método es seguro y por qué.

Tienes dos tokens:

```
token_esperado = "sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3"
token_recibido = "sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3"
```

Pasos:

1. Examina `tokens.json` con los tokens a comparar.
2. Completa `comparacion.json` indicando el resultado de cada método.
3. Marca qué método es vulnerable a timing attacks y cuál es seguro.
4. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `comparacion.json` es JSON válido
- [ ] `coinciden` es `true` (los tokens son iguales)
- [ ] `metodo_igual_doble` es `vulnerable` a timing attacks
- [ ] `metodo_compare_digest` es `seguro` contra timing attacks
- [ ] `explicacion` describe por qué `==` es vulnerable (mínimo 20 caracteres)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La comparación `==` de Python (o `===` de JS) recorre los strings y para en la primera diferencia. Si el primer carácter no coincide, es muy rápido; si coinciden varios, tarda más.
- Un atacante mide esos tiempos para adivinar el token carácter a carácter.
- `hmac.compare_digest(a, b)` (Python) compara siempre en el mismo tiempo, recorriendo ambos strings completos.
- En Python, `secrets.compare_digest` es equivalente y recomendado.
- La función `bcrypt.checkpw` ya usa comparación timing-safe internamente.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`comparacion.json`:

```json
{
  "coinciden": true,
  "metodo_igual_doble": "vulnerable",
  "metodo_compare_digest": "seguro",
  "explicacion": "La comparación == detiene en la primera diferencia, revelando cuántos caracteres coinciden según el tiempo. compare_digest recorre ambos strings completos en tiempo constante, sin filtrar información."
}
```

Demostración del timing attack:

```python
import hmac
import time

token_esperado = "sess_a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3"

# VULNERABLE: == para en la primera diferencia
def comparar_vulnerable(recibido):
    return token_esperado == recibido

# SEGURA: tiempo constante
def comparar_segura(recibido):
    return hmac.compare_digest(token_esperado, recibido)

# Medir tiempos
for prefijo in ["", "s", "se", "ses", "sess"]:
    token = prefijo + "x" * (len(token_esperado) - len(prefijo))
    # == tarda menos cuanto menos coincida
    inicio = time.perf_counter_ns()
    comparar_vulnerable(token)
    t_vuln = time.perf_counter_ns() - inicio
    
    inicio = time.perf_counter_ns()
    comparar_segura(token)
    t_segura = time.perf_counter_ns() - inicio
    print(f"Prefijo '{prefijo:4}': vulnerable={t_vuln}ns, segura={t_segura}ns")
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
