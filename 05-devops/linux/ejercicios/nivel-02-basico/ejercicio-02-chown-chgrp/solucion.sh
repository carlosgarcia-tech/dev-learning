#!/usr/bin/env bash
cd datos
GRUPO=$(id -gn)
USUARIO=$(id -un)
chgrp "$GRUPO" compartido.txt
chown "$USUARIO:$GRUPO" local.txt
chown -R "$USUARIO" carpeta
