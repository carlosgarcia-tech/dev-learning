# Ejercicio 03 — Comparativa REST vs GraphQL vs gRPC

- **Nivel:** 5/5
- **Tema:** Comparativa de arquitecturas de API
- **Tiempo estimado:** 40 min

## Enunciado

Completa `respuesta.json` comparando REST, GraphQL y gRPC en distintos aspectos. Para cada fila, asigna el valor correcto.

El `test.sh` valida tus respuestas contra los valores esperados.

## Requisitos

- [ ] `respuesta.json` es JSON válido
- [ ] `rest.formato` es `JSON`
- [ ] `graphql.formato` es `JSON`
- [ ] `grpc.formato` es `Protobuf`
- [ ] `rest.endpoints` es `multiple` (muchos endpoints)
- [ ] `graphql.endpoints` es `uno` (un solo endpoint)
- [ ] `grpc.endpoints` es `metodos` (métodos del servicio)
- [ ] `mejor_para_api_publica` es `REST`
- [ ] `mejor_para_microservicios` es `gRPC`
- [ ] `evita_over_fetching` es `GraphQL`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- REST y GraphQL usan JSON; gRPC usa Protobuf binario.
- REST tiene muchos endpoints; GraphQL tiene uno solo.
- gRPC expone métodos como si fueran locales.
- REST es ideal para APIs públicas y browser.
- gRPC es ideal para microservicios internos por rendimiento.
- GraphQL evita over-fetching: pides solo lo que necesitas.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`respuesta.json`:

```json
{
  "rest": {"formato": "JSON", "endpoints": "multiple"},
  "graphql": {"formato": "JSON", "endpoints": "uno"},
  "grpc": {"formato": "Protobuf", "endpoints": "metodos"},
  "mejor_para_api_publica": "REST",
  "mejor_para_microservicios": "gRPC",
  "evita_over_fetching": "GraphQL"
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
