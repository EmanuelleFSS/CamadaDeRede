#!/bin/bash
#Camada de Rede

redeTop="/home/emanuelle/Documentos/Redes/camadaRede/redeTop.txt"
redeDown="/home/emanuelle/Documentos/Redes/camadaRede/redeDown.txt"
redeTopResp="/home/emanuelle/Documentos/Redes/camadaRede/redeTopResp.txt"
redeDownResp="/home/emanuelle/Documentos/Redes/camadaRede/redeDownResp.txt"
tableRot="/home/emanuelle/Documentos/Redes/camadaRede/tableRot.txt"
log="/home/emanuelle/Documentos/Redes/camadaRede/logRede.txt"

#escutando outras camadas
while :
do	

	if [ $(stat -c%s "$redeTop") -gt 0 ]; then
		#Recebendo da camada de Transporte
		echo " $( date +%c ) Recebendo da camada de transporte." >> $log
		destino="$( cat $redeTop;)"
		networkDestino=$(echo ${destino:0:9} | sed 's/\.//g')
		netmaskDestino=$(echo ${destino:10:9} | sed 's/\.//g')
			
		#Tabela de roteamento
		echo " $( date +%c ) Verificando a tabela de roteamento." >> $log
		table="$( cat $tableRot;)"		
		network=$(echo ${table:0:9} | sed 's/\.//g') 
		netmask=$(echo ${table:10:9} | sed 's/\.//g')
		gateway=$(echo ${table:20})
		
		if [ $(($network&$netmask)) -ne $(($networkDestino&$netmaskDestino)) ]; then
			echo "Não sei esse caminho amigo! Sorry."
			exit
		else 
			echo "Usando o gateway $gateway"
		fi
		
		#Transmite para a camada fisica
		echo " $( date +%c ) Transmitindo para a camada física." >> $log
		echo $destino >> $redeTopResp
		
		#limpo arquivo redeTop
		echo -n > $redeTop
	fi
	
	if [ $(stat -c%s "$redeDown") -gt 0 ]; then
		#Recebendo da camada Física
		echo " $( date +%c ) Recebendo da camada física." >> $log
		destino="$( cat $redeDown;)"
		networkDestino=$(echo ${destino:0:9} | sed 's/\.//g')
		netmaskDestino=$(echo ${destino:10:9} | sed 's/\.//g')
			
		#Tabela de roteamento
		echo " $( date +%c ) Verificando a tabela de roteamento." >> $log
		table="$( cat $tableRot;)"		
		network=$(echo ${table:0:9} | sed 's/\.//g') 
		netmask=$(echo ${table:10:9} | sed 's/\.//g')
		gateway=$(echo ${table:20})
		
		if [ $(($network&$netmask)) -ne $(($networkDestino&$netmaskDestino)) ]; then
			echo "Não sei esse caminho amigo! Sorry."
			exit
		else 
			echo "Usando o gateway $gateway"
		fi
		
		#Transmite para a camada de transporte
		echo " $( date +%c ) Transmitindo para a camada de transporte." >> $log
		echo $destino >> $redeDownResp
		
		#limpo arquivo redeDown
		echo -n > $redeDown
	fi

	echo "listening"
	sleep 5s
done
