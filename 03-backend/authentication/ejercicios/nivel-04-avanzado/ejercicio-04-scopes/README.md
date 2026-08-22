# Ejercicio 04 — Scopes

- **Nivel:** 4/5
- **Tema:** Scopes y consentimiento de usuario en OAuth
- **Tiempo estimado:** 30 min

## Enunciado

Los **scopes** definen qué permisos solicita el client. El usuario debe consentir explícitamente qué scopes concede. El access token emitido solo tendrá los scopes consentidos.

Tu tarea es completar el flujo de scopes y consentimiento en `scopes.json`.

Escenario:

1. El client solicita: `openid`, `profile`, `email`, `photos:read`, `photos:write`.
2. El usuario consiente `openid`, `profile`, `email`, `photos:read` pero **deniega** `photos:write`.
3. El access token emitido solo tiene los scopes consentidos.

Pasos:

1. Examina los scopes solicitados en `scopes.json`.
2. Completa el consentimiento del usuario y el scope final del token.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `scopes.json` es JSON válido
- [ ] `scopes_solicitados` es un array con 5 elementos
- [ ] `consentimiento` es un array con 5 elementos (uno por scope)
- [ ] Cada elemento de `consentimiento` tiene `scope` y `concedido` (boolean)
- [ ] `photos:write` tiene `concedido: false`
- [ ] Los demás scopes tienen `concedido: true`
- [ ] `scopes_finales` es un array con los 4 scopes concedidos (sin `photos:write`)
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El client solicita 5 scopes pero el usuario solo concede 4.
- El access token final solo tiene los scopes que el usuario consintió.
- `scopes_finales` = `scopes_solicitados` menos los denegados.
- El principio de mínimo privilegio: el client debe pedir solo lo necesario; el usuario puede denegar algunos.
- Los scopes `openid`, `profile`, `email` son de OIDC; `photos:read`, `photos:write` son personalizados.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`scopes.json`:

```json
{
  "scopes_solicitados": ["openid", "profile", "email", "photos:read", "photos:write"],
  "consentimiento": [
    { "scope": "openid", "concedido": true },
    { "scope": "profile", "concedido": true },
    { "scope": "email", "concedido": true },
    { "scope": "photos:read", "concedido": true },
    { "scope": "photos:write", "concedido": false }
  ],
  "scopes_finales": ["openid", "profile", "email", "photos:read"]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
