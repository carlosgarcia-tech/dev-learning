package com.ejercicio.sincronizacion;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.lang.reflect.Method;

/**
 * Suite de tests basica para el ejercicio "Sincronización".
 * Verifica la estructura minima del programa. Amplia estos tests
 * con casos especificos del enunciado a medida que implementas la solucion.
 */
public class MainTest {
    public static void main(String[] args) {
        boolean allTestsPassed = true;

        // Test 1: la clase Main existe
        try {
            Class.forName("com.ejercicio.sincronizacion.Main");
            System.out.println("✅ Test 1: Clase Main encontrada");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Test 1: Clase Main no encontrada");
            allTestsPassed = false;
        }

        // Test 2: el metodo main tiene la firma correcta
        try {
            Method mainMethod = Main.class.getMethod("main", String[].class);
            if (mainMethod != null) {
                System.out.println("✅ Test 2: Método main encontrado");
            }
        } catch (NoSuchMethodException e) {
            System.out.println("❌ Test 2: Método main no encontrado");
            allTestsPassed = false;
        }

        // Test 3: el programa se ejecuta sin lanzar excepciones y produce salida
        try {
            ByteArrayOutputStream outContent = new ByteArrayOutputStream();
            PrintStream originalOut = System.out;
            System.setOut(new PrintStream(outContent));

            Main.main(new String[]{});

            System.setOut(originalOut);

            String output = outContent.toString();
            if (!output.trim().isEmpty()) {
                System.out.println("✅ Test 3: El programa produce salida por consola");
            } else {
                System.out.println("❌ Test 3: El programa no produjo ninguna salida");
                allTestsPassed = false;
            }
        } catch (Exception e) {
            System.out.println("❌ Error al ejecutar el programa: " + e.getMessage());
            allTestsPassed = false;
        }

        // TODO: agrega aqui tests especificos del enunciado de este ejercicio

        if (allTestsPassed) {
            System.out.println("\n✅ ¡Todos los tests basicos pasaron!");
            System.exit(0);
        } else {
            System.out.println("\n❌ Algunos tests fallaron. Revisa el código.");
            System.exit(1);
        }
    }
}
