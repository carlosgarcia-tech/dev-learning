<?php

declare(strict_types=1);

// Autenticación: registro y login de usuarios con password_hash/password_verify,
// y control de sesión y de roles (admin/autor).
class Auth
{
    public function __construct(
        private Almacenamiento $almacenamiento,
        private Sesion $sesion,
    ) {
    }

    public function registrar(string $nombre, string $clave, string $rol = 'autor'): bool
    {
        // TODO: valida credenciales, comprueba que el nombre no exista,
        // guarda el usuario con password_hash($clave, PASSWORD_DEFAULT)
        // y asigna id = siguienteId(). Devuelve true.
        throw new Exception("TODO: implementar Auth::registrar()");
    }

    public function listarUsuarios(): array
    {
        // TODO: devuelve todos los usuarios.
        throw new Exception("TODO: implementar Auth::listarUsuarios()");
    }

    public function buscarPorNombre(string $nombre): ?array
    {
        // TODO: devuelve el usuario con ese nombre o null.
        throw new Exception("TODO: implementar Auth::buscarPorNombre()");
    }

    public function login(string $nombre, string $clave): bool
    {
        // TODO: verifica con password_verify y, si es correcto,
        // guarda usuario_id, usuario_nombre y usuario_rol en la sesión.
        throw new Exception("TODO: implementar Auth::login()");
    }

    public function logout(): void
    {
        // TODO: destruye la sesión.
        throw new Exception("TODO: implementar Auth::logout()");
    }

    public function estaAutenticado(): bool
    {
        // TODO: true si hay un usuario en sesión.
        throw new Exception("TODO: implementar Auth::estaAutenticado()");
    }

    public function usuarioActual(): ?array
    {
        // TODO: devuelve el usuario de la sesión (buscándolo en el almacenamiento) o null.
        throw new Exception("TODO: implementar Auth::usuarioActual()");
    }

    public function rolActual(): ?string
    {
        // TODO: devuelve el rol guardado en sesión o null.
        throw new Exception("TODO: implementar Auth::rolActual()");
    }

    public function esAdmin(?string $rol = null): bool
    {
        // TODO: true si el rol (o el de la sesión) es 'admin'.
        throw new Exception("TODO: implementar Auth::esAdmin()");
    }
}