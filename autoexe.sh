#!/bin/bash

ARQUIVO_C=$1
PARAMETROS_EXECUTAVEL=$2

arquivos_h=$(ls *.h)
if [ $? -eq '0' ]; then 
	ARQUIVOS_H=$arquivos_h
fi

executavel=$(echo $ARQUIVO_C | awk '{split ($ 0, array, ".")} END {print array [1]}');

function compilar {
	clear
	echo "[Compilado: $(date +%T)]"
	echo ""
	rm -f $executavel
	gcc $ARQUIVO_C -o $executavel 
	if [ $? -eq '0' ]; then 
		./$executavel $PARAMETROS_EXECUTAVEL
	fi
}

ESCUTAVEIS=$"$ARQUIVO_C $ARQUIVOS_H $PARAMETROS_EXECUTAVEL"
compilar
while inotifywait -q -e close_write $ESCUTAVEIS; do compilar; done