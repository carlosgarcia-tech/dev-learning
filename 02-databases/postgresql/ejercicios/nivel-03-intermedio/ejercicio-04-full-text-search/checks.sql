SELECT COUNT(*) FROM articulos WHERE documento @@ to_tsquery('spanish', 'PostgreSQL');
