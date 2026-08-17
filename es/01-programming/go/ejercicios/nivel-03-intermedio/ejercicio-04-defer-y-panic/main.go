package main

import "fmt"

// TODO: divide a/b. Si b es 0, lanza un panic con "división por cero" y recupéralo con defer/recover devolviendo un error.
func dividirSeguro(a, b int) (resultado int, err error) {
	return 0, nil // TODO: completa la función
}

// TODO: ejecuta fn. Si fn lanza un panic, lo captura con recover y lo devuelve como error.
func ejecutarSeguro(fn func()) (err error) {
	return nil // TODO: completa la función
}
func main() {
	fmt.Println(dividirSeguro(10, 2))
	fmt.Println(dividirSeguro(7, 0))
	fmt.Println(ejecutarSeguro(func() { panic("boom") }))
}
