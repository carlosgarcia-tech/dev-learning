#!/usr/bin/env bash
cd repo
head -n 5 servidor.log > primeras.txt
tail -n 3 servidor.log > ultimas.txt
find . -name "*.py" > lista_py.txt
find . -name "*.py" | wc -l > cuenta_py.txt
grep -rn "TODO" --include=*.py . > todos.txt
