#!/bin/bash 
#*******************PROGRAMA PARA CONECTAR A INTERNET POR CABLE*******************
#variables: 
opcionH=""
opcionU=""
opcionD=""
opcionV=""
opcionA=""
opcionS=""
#verificacion (hace que el script se corra con privilegios)
if [ "$(id -u )" != "0" ]; then
	echo "Este script debe correr como root";
	exit;
fi
while getopts ":hduvsa" opt; do
    case $opt in 
        h)
            opcionH="1";
            ;;
        u)
            opcionU="1";
            ;;
        d)
            opcionD="1";
            ;;
		v)
            opcionV="1";
	    	;;
		a)
			opcionA="1";
			;;
		s)
			opcionS="1";
			;;
        "?")
            echo "CUIDADO: opcion invalida";
            opcionH="1";
            ;;
    esac
done 
#funcion de ayuda
if  [ $opcionH ]; then
    echo " "
    echo "---------------> OPCIONES <-----------------------"
    echo "script para conectar a servidor DHCP"
    echo "opciones disponibles:"
    echo "./redCableada.sh -u INTERFAZ : levantar interfaz"
    echo "./redCableada.sh -d INTERFAZ : dar de baja la interfaz"
	echo "./redCableada.sh -a INTERFAZ : ip de manera dinamica"
	echo "./redCableada.sh -s INTERFAZ : ip estatica"
    echo "./redCableada.sh -v : caracteristicas"
    echo " "
fi
if [ $opcionU ]; then
	echo "levantar la interfaz..."
    	ip link set $2 up
fi
if [ $opcionD ]; then 
    	echo "seleccionaste dar de baja la interfaz $2"
    	ip link set $2 down
    	echo "interfaz dada de baja EXITOSAMENTE..."
	echo "comprobando:"
	ip add | grep $2
fi
if [ $opcionV ]; then
	echo "revisando configuraciones en la red: "
	ip add | grep $2
	echo " "
	echo "---------------"
	ip route
fi
if [ $opcionA ]; then
	echo "conectando de manera dinamica"
	echo "solicitando direccion IP a la interfaz: $2"
   	 dhclient -v  $2
    	echo "asignando con EXITO..."
    	echo " "
	echo  "tu configuracion de red quedo de la siguiente manera:"
    	ip route
    	echo " "
	echo "comprobando..."
    	ping -c 4 www.google.com
fi
if [ $opcionS ]; then 
	echo "conectando de manera estatica"
	echo "IP: "
	read ip
	echo "prefijo:"
	read pref
	echo "direccion de brd:"
	read brd
	ip addr add $ip/$pref brd $brd dev $2
	echo "Direccion asiganada correctamente..."
fi
#Creado por José Rafael (carmonajose148@gmail.com)