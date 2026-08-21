#!/usr/bin/env bash
mkdir -p destino
cp origen/config.yml destino/config.yml
cp -r origen/notas destino/
mv origen/plantilla.html destino/index.html
rm origen/config.yml
