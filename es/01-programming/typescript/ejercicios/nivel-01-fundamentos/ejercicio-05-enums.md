# Ejercicio 05 — Enums

- **Nivel:** 1/5
- **Tema:** `enum` numérico, `enum` de string, acceso por nombre e índice
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `enums.ts` que:

1. Declare un `enum` numérico `Dia` con `Lunes`, `Martes`, `Miercoles` y `Domingo` al final.
2. Declare un `enum` de string `Rol` con `Admin = "admin"`, `Usuario = "usuario"` e `Invitado = "invitado"`.
3. Escriba una función `nombreDia(dia: Dia): string` que devuelva el nombre del día usando el mapeo inverso del enum.
4. Escriba una función `esAdmin(rol: Rol): boolean` que devuelva `true` solo para `Rol.Admin`.
5. Imprima el resultado de las funciones con varios valores.

Salida esperada (ejemplo):

```
Dia 2: Miercoles
Dia 3: Domingo
Es admin admin: true
Es admin usuario: false
```

## Requisitos

- [ ] Declarar un enum numérico y usar su mapeo inverso (`Dia[n]`).
- [ ] Declarar un enum de string y usarlo en una función con parámetro tipado.
- [ ] Comprobar con `===` contra los miembros del enum.
- [ ] Ejecutarlo localmente con `npx tsc --strict --outDir dist enums.ts` y luego `node dist/enums.js`, y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Enum numérico: `enum Dia { Lunes, Martes, Miercoles, Domingo }` → `Lunes` es `0`, `Miercoles` es `2`.
- El mapeo inverso funciona en enums numéricos: `Dia[2]` devuelve `"Miercoles"`.
- Enum de string: `enum Rol { Admin = "admin", Usuario = "usuario", Invitado = "invitado" }` — el mapeo inverso NO existe aquí.
- Para comparar: `rol === Rol.Admin`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --outDir dist enums.ts && node dist/enums.js
enum Dia {
  Lunes,
  Martes,
  Miercoles,
  Domingo,
}

enum Rol {
  Admin = "admin",
  Usuario = "usuario",
  Invitado = "invitado",
}

function nombreDia(dia: Dia): string {
  return Dia[dia];
}

function esAdmin(rol: Rol): boolean {
  return rol === Rol.Admin;
}

console.log(`Dia 2: ${nombreDia(2)}`);
console.log(`Dia 6: ${nombreDia(Dia.Domingo)}`);
console.log(`Es admin ${Rol.Admin}: ${esAdmin(Rol.Admin)}`);
console.log(`Es admin ${Rol.Usuario}: ${esAdmin(Rol.Usuario)}`);
````

</details>