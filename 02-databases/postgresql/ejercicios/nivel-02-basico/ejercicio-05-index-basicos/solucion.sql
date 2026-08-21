CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_libros_isbn ON libros(isbn);
CREATE INDEX idx_prestamos_usuario_fecha ON prestamos(usuario_id, fecha_prestamo);
