#!/bin/bash

opcion=0
PARAMETRO_LIMPIEZA="-d"

if [ "$1" == "$PARAMETRO_LIMPIEZA" ];
then
	echo "Modo limpieza activado."
	echo
	if [ -f "$HOME/EPNro1/proceso.activo" ]; then
		pkill -f "$HOME/EPNro1/consolidar.sh"
		echo "Procesos finalizados."
	else
		echo "No existen procesos activos en este momento."
	fi
	echo
	
	if [ -d "$HOME/EPNro1" ]; then
		rm -rf "$HOME/EPNro1"
		echo "Entorno eliminado."
	else
		echo "No existe el entorno EPNro1."
	fi
	echo
	read -r -p "Presione ENTER para cerrar el modo limpieza."
	clear
	exit 0
fi

while [ "$opcion" != "7" ] 	# Las comillas en opcion aseguran que el script no falle si se ingresa un valor vacio

do

	clear #Limpiamos la terminal, así no se imprime las opciones siempre.
	echo "Bienvenido al menú"
	echo
	echo "1) Crear entorno"
        echo "2) Correr Proceso"
        echo "3) Listar alumnos"
        echo "4) Mostrar 10 notas mas altas"
        echo "5) Buscar alumno por padron"
        echo "6) Visualizar log"
        echo "7) Salir"
	read -s -n 1 opcion
		#-s no imprime la opcion elegida en la terminal
		#-n 1 se lee el primer caracter ingresado y no hace falta presionar enter

	case $opcion in
	1)
		if [ -d "$HOME/EPNro1" ]; then		#-d da verdadero si existe el directorio
			echo
			echo "El entorno ya existe."
		else
			mkdir -p "$HOME/EPNro1"/{entrada,salida,procesado}
				#-p nos deja crear directorios y sub directorios todos juntos y no hace nada si las carpetas ya existen 
				#%HOME = /home/user/..., incluso cuando "user" utiliza otro nombre
			echo
			echo "El entorno ha sido creado."

		fi
		read -p "Presione ENTER para continuar..."
		;;
	2)
    	if [ -d "$HOME/EPNro1" ]; then

        	if [ -f "$HOME/EPNro1/proceso.activo" ]; then
            	echo
            	echo "El proceso ya está corriendo"

        	else
        	    if [ -z "$FILENAME" ]; then
            	    echo
            	    echo "Error: FILENAME no está definida"

        	    else
            	    cp "./consolidar.sh" "$HOME/EPNro1/consolidar.sh"
            	    chmod 744 "$HOME/EPNro1/consolidar.sh"

            	    "$HOME/EPNro1/consolidar.sh" &

            	    touch "$HOME/EPNro1/proceso.activo"

            	    echo
            	    echo "Proceso iniciado"
            	fi
        	fi

    	else
    	    echo
    	    echo "Primero debe crear el entorno con la opción 1"
	    fi

    	read -p "Presione ENTER para continuar..."
    	;;
    3)
        if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ];
        then
		echo
        echo "==Alumnos en orden por padron=="
           sort -n -k1,1 "$HOME/EPNro1/salida/$FILENAME.txt"
        else
           echo
		   echo "No existe el archivo $FILENAME.txt"
        fi
           read -p "Ingrese ENTER  para continuar ...."
        ;;


    4)
		echo
        echo "Notas mas altas: "
        if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
           sort -k5 -nr  "$HOME/EPNro1/salida/$FILENAME.txt" | head -10
        else
           echo  "No existe el archivo $FILENAME.txt"
        fi
           read -p "Ingrese ENTER  para continuar ...."
        ;;


    5)
		echo
        read -p "Ingrese el numero de padron: " padron
        if [ -f "$HOME/EPNro1/salida/$FILENAME.txt" ]; then
   	        alumno=$(grep "^$padron " "$HOME/EPNro1/salida/$FILENAME.txt")
			if [ -z "$alumno" ]; then
				echo "No existe un alumno con el padron $padron"
			else
				echo "$alumno"
			fi
		else
            echo  "No existe el archivo $FILENAME.txt"
        fi
        read -p "Ingrese ENTER  para continuar ...."
        ;;
    6)
		if [ -f "$HOME/EPNro1/procesado.log" ]; then
		    echo
		    cat "$HOME/EPNro1/procesado.log"
		else
		    echo
		    echo "Todavia no existe el archivo de log"
		fi

		read -p "Presione ENTER para continuar..."
	;;
    7)
		echo
		echo "Cerrando menu..."
		sleep 1.5
		;;
    *)
		echo
		echo "Opcíon no válida."
		read -p "Presione ENTER para continuar..."

    esac

done
