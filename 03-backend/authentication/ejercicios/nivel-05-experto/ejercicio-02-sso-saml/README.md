# Ejercicio 02 — SSO SAML

- **Nivel:** 5/5
- **Tema:** Single Sign-On con SAML
- **Tiempo estimado:** 40 min

## Enunciado

SAML (Security Assertion Markup Language) es el estándar de SSO empresarial. Un IdP (Identity Provider) emite aserciones XML firmadas que un SP (Service Provider) consume para autenticar al usuario.

Tu tarea es completar una aserción SAML simplificada y el flujo de SSO en `saml.json`.

Flujo SAML:

1. Usuario accede al SP → SP redirige al IdP.
2. Usuario se autentica en el IdP.
3. IdP genera una aserción SAML firmada.
4. IdP envía la aserción al SP (vía POST o redirect).
5. SP verifica la firma y extrae los claims del usuario.

Pasos:

1. Completa `saml.json` con la aserción y el flujo.
2. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `saml.json` es JSON válido
- [ ] `idp.entity_id` no está vacío
- [ ] `sp.entity_id` no está vacío
- [ ] `asercion.subject` es el email del usuario
- [ ] `asercion.issuer` coincide con `idp.entity_id`
- [ ] `asercion.audience` coincide con `sp.entity_id`
- [ ] `asercion.atributos` contiene `role` y `email`
- [ ] `asercion.firmada` es `true`
- [ ] `flujo` tiene 5 pasos
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- SAML usa XML, pero en este ejercicio lo modelamos como JSON para simplificar.
- El `issuer` de la aserción es siempre el IdP.
- El `audience` de la aserción es el SP que la solicita.
- La aserción está firmada por el IdP con su clave privada; el SP la verifica con la clave pública del IdP.
- El `subject` identifica al usuario (normalmente por email o NameID).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`saml.json`:

```json
{
  "idp": {
    "entity_id": "https://idp.example.com",
    "sso_url": "https://idp.example.com/sso"
  },
  "sp": {
    "entity_id": "https://app.example.com",
    "acs_url": "https://app.example.com/acs"
  },
  "asercion": {
    "subject": "alice@example.com",
    "issuer": "https://idp.example.com",
    "audience": "https://app.example.com",
    "atributos": {
      "email": "alice@example.com",
      "role": "admin",
      "name": "Alice García"
    },
    "firmada": true,
    "authn_instant": "2025-01-15T10:30:00Z"
  },
  "flujo": [
    { "paso": 1, "accion": "Usuario accede al SP; SP redirige al IdP" },
    { "paso": 2, "accion": "Usuario se autentica en el IdP" },
    { "paso": 3, "accion": "IdP genera la aserción SAML firmada" },
    { "paso": 4, "accion": "IdP envía la aserción al SP vía POST (SAML Response)" },
    { "paso": 5, "accion": "SP verifica la firma y extrae los claims; usuario autenticado" }
  ]
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
