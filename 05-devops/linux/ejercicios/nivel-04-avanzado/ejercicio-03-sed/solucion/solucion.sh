#!/usr/bin/env bash
sed -e 's/localhost/0.0.0.0/g' -e 's/true/false/g' config.conf > cambiado.txt
sed 's/[a-z]/\U&/g' config.conf > mayus.txt
sed '/^#/d' config.conf > sin_comentarios.txt
