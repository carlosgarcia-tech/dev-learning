# Ejercicio 03 — Firma GPG

- **Nivel:** 5/5
- **Tema:** Firma de commits con GPG
- **Tiempo estimado:** 30 minutos

## Enunciado

1. El repo está en `main` con 1 commit.
2. Configura Git para firmar commits (sin GPG real, simulando la configuración).
3. Crea un commit con la bandera `-S` (firmar) y el mensaje `feat: commit firmado`.
4. Verifica la firma con `git log --show-signature`.

Como no podemos garantizar que tengas una clave GPG configurada en el entorno de test, el ejercicio se centra en:
- Configurar `commit.gpgsign` y `user.signingkey` (aunque el valor sea simulado).
- Crear un commit con `-S`.
- Dado que GPG puede no estar disponible, el test verifica la **configuración** y la presencia del commit, y usa `git -c commit.gpgsign=false` como fallback para no bloquear el ejercicio.

## Requisitos

- [ ] `commit.gpgsign` está configurado a `true`
- [ ] `user.signingkey` tiene un valor configurado
- [ ] Existe un commit con el mensaje `feat: commit firmado`
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `git config commit.gpgsign true` activa el firmado.
- `git config user.signingkey DEADBEEF` establece la clave (simulada para el ejercicio).
- `git commit -S -m "..."` fuerza el firmado de ese commit.
- Si GPG no está disponible en el entorno, usa `git -c commit.gpgsign=false commit -m "..."` para crear el commit sin firmar (el test acepta ambos).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```bash
cd "$REPO_DIR"
git config commit.gpgsign true
git config user.signingkey DEADBEEFDEADBEEF
echo "firmado" > firmado.txt
git add firmado.txt
# Intentar con firma; si GPG no está disponible, crear sin firma
git commit -S -q -m "feat: commit firmado" 2>/dev/null || git -c commit.gpgsign=false commit -q -m "feat: commit firmado"
```

</details>
