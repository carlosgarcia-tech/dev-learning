-- Empiezan con 'Te'
SELECT * FROM productos WHERE nombre LIKE 'Te%';

-- Contienen 'ra'
SELECT * FROM productos WHERE nombre LIKE '%ra%';

-- Terminan con 'o'
SELECT * FROM productos WHERE nombre LIKE '%o';

-- Exactamente 6 caracteres
SELECT * FROM productos WHERE nombre LIKE '______';
