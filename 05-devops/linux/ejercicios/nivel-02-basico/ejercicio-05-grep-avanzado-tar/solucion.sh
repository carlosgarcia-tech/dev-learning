#!/usr/bin/env bash
cd logs
grep -n "ERROR" *.log > errores.txt
grep -iv "debug" *.log > sin_debug.txt
grep -c "WARNING" *.log > cuenta_warning.txt
grep -E "ERROR|INFO" *.log > errores_o_info.txt
tar czf backup.tar.gz *.log
tar tzf backup.tar.gz > contenido_tar.txt
