package main

import "fmt"

// TODO: devuelve el día de la semana para n (1=lunes ... 7=domingo). Si n no está en 1..7 devuelve "número inválido".
func diaDeLaSemana(n int) string {
	return "" // TODO: completa la función
}

// TODO: devuelve el mes para n (1=enero ... 12=diciembre). Si n no está en 1..12 devuelve "mes inválido".
func mesEnLetras(n int) string {
	return "" // TODO: completa la función
}

// TODO: devuelve "suspenso" (<60), "aprobado" (<75), "notable" (<90) o "sobresaliente" (>=90) usando switch.
func clasificarNota(nota float64) string {
	return "" // TODO: completa la función
}

// TODO: devuelve "entero: X", "texto: X" o "decimal: X" según el tipo, y "tipo desconocido" para el resto. Usa un type switch.
func describirValor(v interface{}) string {
	return "" // TODO: completa la función
}
func main() {
	fmt.Println(diaDeLaSemana(3))
	fmt.Println(mesEnLetras(12))
	fmt.Println(clasificarNota(85))
	fmt.Println(describirValor(42))
}
