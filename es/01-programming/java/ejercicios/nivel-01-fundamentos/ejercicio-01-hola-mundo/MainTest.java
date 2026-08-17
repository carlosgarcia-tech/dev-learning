package com.ejercicio.holamundo;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.lang.reflect.Method;

public class MainTest {
    public static void main(String[] args) {
        boolean allTestsPassed = true;

        // Test 1: Verificar que la clase Main existe
        try {
            Class.forName("com.ejercicio.holamundo.Main");
            System.out.println("✅ Test 1: Clase Main encontrada");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Test 1: Clase Main no encontrada");
            allTestsPassed = false;
        }

        // Test 2: Verificar que el método main existe con la firma correcta
        try {
            Method mainMethod = Main.class.getMethod("main", String[].class);
            if (mainMethod != null) {
                System.out.println("✅ Test 2: Método main encontrado");
            }
        } catch (NoSuchMethodException e) {
            System.out.println("❌ Test 2: Método main no encontrado");
            allTestsPassed = false;
        }

        // Test 3 y 4: Verificar la salida del programa
        try {
            ByteArrayOutputStream outContent = new ByteArrayOutputStream();
            PrintStream originalOut = System.out;
            System.setOut(new PrintStream(outContent));

            Main.main(new String[]{});

            System.setOut(originalOut);

            String output = outContent.toString();
            if (output.contains("¡Hola, mundo!") || output.contains("Hola, mundo")) {
                System.out.println("✅ Test 3: Mensaje '¡Hola, mundo!' encontrado");
            } else {
                System.out.println("❌ Test 3: Mensaje '¡Hola, mundo!' no encontrado");
                allTestsPassed = false;
            }

            String[] lines = output.trim().split("\\n");
            if (lines.length >= 2) {
                System.out.println("✅ Test 4: Saludo personalizado encontrado");
            } else {
                System.out.println("❌ Test 4: No hay saludo personalizado");
                allTestsPassed = false;
            }

        } catch (Exception e) {
            System.out.println("❌ Error al ejecutar el programa: " + e.getMessage());
            allTestsPassed = false;
        }

        if (allTestsPassed) {
            System.out.println("\n✅ ¡Todos los tests pasaron!");
            System.exit(0);
        } else {
            System.out.println("\n❌ Algunos tests fallaron. Revisa el código.");
            System.exit(1);
        }
    }
}
