#!/bin/bash

BASE="$HOME/EPNro1"
ENTRADA="$BASE/entrada"
SALIDA="$BASE/salida"
PROCESADO="$BASE/procesado"
LOG="$BASE/procesado.log"

if [ -z "$FILENAME" ]
then
	echo
	echo "Error: FILENAME no está definida"
        exit 1
fi

while [ -d "$BASE" ]
do
        for archivo in "$ENTRADA/"*.txt
        do
                if [ -f "$archivo" ]
                then
                        cat "$archivo" >> "$SALIDA/$FILENAME.txt"
                        mv "$archivo" "$PROCESADO/"
                        echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $(basename "$archivo")" >> "$LOG"
                fi
        done

        sleep 5 
done
