#!/usr/bin/env bash
ln -s src/config/app.conf acceso.conf
ln -s src/original.txt link_origen.txt
ln src/original.txt duro.txt
readlink acceso.conf > verificacion.txt
