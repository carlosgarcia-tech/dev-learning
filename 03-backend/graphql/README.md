# graphql

> Guía de estudio + ejercicios por niveles. Todo en español.

GraphQL es un lenguaje de consultas para APIs creado por Facebook en 2012 y liberado en 2015. A diferencia de REST, donde el servidor define qué datos devuelve cada endpoint, en GraphQL **el cliente decide exactamente qué campos necesita** en una sola petición a un único endpoint (`/graphql`).

Este tema cubre desde los fundamentos del lenguaje hasta arquitecturas de producción con Apollo Server, DataLoader y federation.

## Guías

| # | Guía | Qué cubre |
|---|---|---|
| 01 | [Fundamentos](01-fundamentos.md) | Qué es GraphQL, REST vs GraphQL, over/under-fetching, schema, type system, query básica, introspection, endpoint único |
| 02 | [Queries y Mutations](02-queries-y-mutations.md) | Field selection, nested fields, aliases, fragments, variables, directives, mutations, input types, paginación, errores, nullabilidad |
| 03 | [Schema y Tipos](03-schema-y-tipos.md) | Object types, Scalar, Enum, Interface, Union, Input type, SDL, custom scalar, relaciones, esquemas modulares |
| 04 | [Resolvers y DataSources](04-resolvers-y-datasources.md) | Resolvers (parent, args, context, info), data sources, context, N+1 y DataLoader, caching, async, error handling |
| 05 | [Producción y Seguridad](05-produccion-y-seguridad.md) | Apollo Server/Client, subscriptions, JWT, autorización por campo, rate limiting, query complexity, persisted queries, federation, monitoreo |

## Ejercicios

Ver [ejercicios/](ejercicios/)

| Nivel | Qué cubre | Estado |
|---|---|---|
| [nivel-01-fundamentos](ejercicios/nivel-01-fundamentos/) | Definir type, query simple, argumentos, alias, fragments, variables, introspection | ⬜ |
| [nivel-02-basico](ejercicios/nivel-02-basico/) | Mutations (crear/actualizar), enum, input type, nullabilidad, errores | ⬜ |
| [nivel-03-intermedio](ejercicios/nivel-03-intermedio/) | Interface, union, relaciones, paginación, custom scalar, fragmentos avanzados | ⬜ |
| [nivel-04-avanzado](ejercicios/nivel-04-avanzado/) | Resolvers, DataLoader N+1, context y auth, subscriptions, query complexity | ⬜ |
| [nivel-05-experto](ejercicios/nivel-05-experto/) | Apollo Server, federation, persisted queries, depth limiting, schema stitching, producción | ⬜ |
| [proyectos](ejercicios/proyectos/) | API GraphQL de blog completo (proyecto integrador) | ⬜ |
