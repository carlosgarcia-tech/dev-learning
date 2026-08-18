import { describe, it } from 'node:test';
import assert from 'node:assert';
import { crearPresentacion, identificarTipo, valorString, valorNumero } from './index';

describe('Ejercicio 01 - Tipos Básicos', () => {
    it('crearPresentacion debería generar el texto correcto', () => {
        const resultado = crearPresentacion('Ana', 30);
        assert.strictEqual(resultado, 'Hola, me llamo Ana y tengo 30 años.');
    });

    it('identificarTipo debería distinguir string de number', () => {
        assert.strictEqual(identificarTipo('hola'), 'Es un string: "hola"');
        assert.strictEqual(identificarTipo(42), 'Es un número: 42');
    });

    it('debería usar type assertions correctamente', () => {
        assert.strictEqual(typeof valorString, 'string');
        assert.strictEqual(typeof valorNumero, 'number');
        assert.strictEqual(valorNumero, 123);
    });
});
