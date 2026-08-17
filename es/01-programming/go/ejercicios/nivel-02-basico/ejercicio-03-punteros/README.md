# Ejercicio 03 — Punteros

- **Nivel:** 2/5
- **Tema:** punteros (`*T`, `&`), modificación de valores por referencia
- **Tiempo estimado:** 25 min

## Enunciado

Completa el archivo `main.go` para que:

1. `incrementar(p *int)` sume 1 al valor al que apunta `p`.
2. `intercambiar(a, b *int)` intercambie los valores a los que apuntan `a` y `b`.
3. `duplicarValores(ns []int)` multiplique por 2 cada elemento del slice, modificando el original (los slices ya comparten el array subyacente).
4. `envejecer(p *Persona)` incremente en 1 la edad de la persona original (no de una copia).

## Requisitos

- [ ] `incrementar(&n)` cambia `n` de `1` a `2`; aplicado 3 veces pasa de `0` a `3`.
- [ ] `intercambiar(&a, &b)` deja `a=20` y `b=10` partiendo de `10` y `20`.
- [ ] `duplicarValores([]int{1,2,3})` deja el slice en `[2 4 6]`.
- [ ] `envejecer(&p)` sube `p.Edad` de `30` a `31`.
- [ ] Los tests pasan: `go test ./...`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Para modificar el valor apuntado usa `*p = ...` (desreferenciar). `p` sin asterisco es la dirección.
- `*p += 1` y `*p = *p + 1` son equivalentes.
- En `intercambiar` guarda temporalmente uno de los valores: `temporal := *a; *a = *b; *b = temporal`.
- En `envejecer` usa `p.Edad++` — Go desreferencia automáticamente los campos de un puntero a struct.
- Los slices no necesitan puntero explícito: modificar `ns[i]` afecta al slice original del llamador.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````go
package main

// Persona con nombre y edad (se usa con punteros).
type Persona struct {
	Nombre string
	Edad   int
}

func incrementar(p *int) {
	*p += 1
}

func intercambiar(a, b *int) {
	temporal := *a
	*a = *b
	*b = temporal
}

func duplicarValores(ns []int) {
	for i := range ns {
		ns[i] *= 2
	}
}

func envejecer(p *Persona) {
	p.Edad++
}
````

</details>