# Ejercicios — graphql

Cada ejercicio es una carpeta con enunciado (`README.md`), tests (`test.sh`) y archivos de soporte (`schema.graphql`, `query.graphql`, `expected.json`). La solución está al final del README del ejercicio en un bloque plegable.

Para validar un ejercicio:

```bash
bash test.sh
```

Salida `OK Tests pasaron` (exit 0) o `FAIL Tests fallaron` (exit 1).

## Niveles

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](nivel-01-fundamentos/) | Definir type básico, query simple, argumentos, alias y fragments, variables, introspection | ⬜ |
| [nivel-02-basico](nivel-02-basico/) | Mutation crear, mutation actualizar, enum type, input type, nullabilidad, errores | ⬜ |
| [nivel-03-intermedio](nivel-03-intermedio/) | Interface, union type, relaciones one-to-many, paginación, custom scalar, fragmentos avanzados | ⬜ |
| [nivel-04-avanzado](nivel-04-avanzado/) | Resolver básico, DataLoader N+1, context y auth, subscription WebSocket, query complexity | ⬜ |
| [nivel-05-experto](nivel-05-experto/) | Apollo Server completo, federation, persisted queries, depth limiting, schema stitching, producción | ⬜ |
| [proyectos](proyectos/) | API GraphQL de blog completo | ⬜ |

## Convenciones

- **schema.graphql**: definición del esquema en SDL.
- **query.graphql**: query o mutation de ejemplo.
- **expected.json**: respuesta JSON esperada (formato GraphQL).
- **test.sh**: script que valida sintaxis y estructura. Usa `grep`/`awk` y `python3` cuando está disponible.
