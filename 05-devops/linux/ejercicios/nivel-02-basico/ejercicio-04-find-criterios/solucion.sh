#!/usr/bin/env bash
cd archivos
find . -type d > por_tipo_dir.txt
find . -type f > por_tipo_archivo.txt
find . -name "*.bak" > por_nombre_bak.txt
find . -size +10k > por_tamano.txt
find . -empty > vacios.txt

echo '#!/bin/bash' > script.sh
find . -name "*.sh" -exec chmod +x {} \;
find . -name "*.sh" -exec ls -l {} \; > ejecutar_chmod.txt
