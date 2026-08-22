# Ejercicios — Arquitectura de Software

Cada ejercicio tiene enunciado, requisitos, pistas y solución (plegables). Los `test.sh` validan estructura de archivos y código con `python3` (y `node --check` cuando corresponde).

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | Identificar capas, separar responsabilidades (SRP), Factory, Singleton, Open/Closed | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | Repository pattern, Strategy, Observer, arquitectura en capas, Dependency Injection | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | Clean Architecture (entities + use cases), hexagonal ports-adapters, Builder, Decorator, Command | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | Diseñar microservicio, DDD bounded context, CQRS, Circuit Breaker, API Gateway | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | Event-driven, event sourcing, Saga, escalabilidad horizontal, sistema 12-factor | ⬜ |
| [proyectos](proyectos/) | Arquitectura de microservicios completa para e-commerce | ⬜ |

## Cómo usar los ejercicios

1. Entra a la carpeta del ejercicio.
2. Lee el `README.md` con el enunciado y requisitos.
3. Examina `estructura.json` (estructura esperada) y `diagrama.txt` (diagrama ASCII).
4. Implementa tu solución en `solucion.js` o `solucion.py`.
5. Ejecuta `bash test.sh` para validar.

```bash
cd 03-backend/architecture/ejercicios/nivel-01-fundamentos/ejercicio-01-identificar-capas
bash test.sh
```

> Los `test.sh` requieren `python3`. Algunos además usan `node --check` para validar JavaScript.
> Las soluciones de referencia (`solucion.js`/`solucion.py`) ya están incluidas; úsalas para estudiar tras intentar el ejercicio.

## Requisitos de entorno

- `python3` (obligatorio).
- `node` (para ejercicios con JavaScript).
- `bash` 4+.

Comprueba que los tienes:

```bash
python3 --version
node --version
bash --version | head -1
```
