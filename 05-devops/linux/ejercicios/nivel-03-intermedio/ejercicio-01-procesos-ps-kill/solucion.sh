#!/usr/bin/env bash
set -uo pipefail

sleep 300 &
PID=$!
ps -p "$PID" > proceso.txt

if kill -0 "$PID" 2>/dev/null; then
  echo "vivo" > estado.txt
else
  echo "muerto" > estado.txt
fi

kill "$PID" 2>/dev/null || true
sleep 0.5

if kill -0 "$PID" 2>/dev/null; then
  echo "vivo" > estado_final.txt
else
  echo "muerto" > estado_final.txt
fi

ps aux | grep "[s]leep" > todos_sleep.txt || true
