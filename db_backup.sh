#!/bin/bash

dir=$(pwd)		#Diretório do backup
dir=$dir/db_backup		#Nome da pasta de backup
backup_file=$(date "+%d_%m_%Y").sql		#Padrão do arquivo (dia_mes_ano.sql)
sem=$(date "+%A")		#Padrão de diretório (dia da semana)

#DB config
dbhost=host
dbuser=user
dbpass=pass
dbname=name

#Cria diretório do backup
if [ ! -d "$dir" ]; then
	mkdir $dir
	if [ -d "$dir" ]; then
		echo -e "\033[1;33m[DIRETÓRIO CRIADO] $dir/\033[0m"
	else
		echo -e "\033[1;31m[ERRO AO CRIAR DIRETÓRIO] $dir/\033[0m"
	fi
fi

#Cria pasta referente ao padrão de diretório
if [ ! -d "$dir/$sem" ]; then
	mkdir $dir/$sem
	if [ -d "$dir/$sem" ]; then
		echo -e "\033[1;33m[DIRETÓRIO CRIADO] $dir/$sem\033[0m"
	else
		echo -e "\033[1;31m[ERRO AO CRIAR DIRETÓRIO] $dir/$sem\033[0m"
	fi
fi

cd $dir/$sem

#Remove backups antigos da pasta
if [ -e $dir/$sem/$(date +%d_%m_%Y -d "7 days ago").sql ]; then
	rm $(date +%d_%m_%Y -d "7 days ago").sql
	if [ ! -e $dir/$sem/$(date +%d_%m_%Y -d "7 days ago").sql ]; then
		echo -e "\033[1;34m[BACKUP ANTIGO DELETADO] $dir/$sem/$(date +%d_%m_%Y -d "7 days ago").sql em $(date "+%d/%m/%Y")\033[0m"
	else
		echo -e "\033[1;31m[ERRO AO DELETAR BACKUP ANTIGO] $dir/$sem/$(date +%d_%m_%Y -d "7 days ago").sql em $(date "+%d/%m/%Y")\033[0m"
	fi
fi

#Cria backup atual na pasta
mysqldump -h $dbhost -u $dbuser -p$dbpass $dbname > $backup_file

if [ -e $dir/$sem/$backup_file ]; then
	echo -e "\033[1;32m[BACKUP CRIADO] $dir/$sem/$backup_file em $(date "+%d/%m/%Y")\033[0m"
else
	echo -e "\033[1;31m[ERRO AO CRIAR BACKUP] $dir/$sem/$backup_file em $(date "+%d/%m/%Y")\033[0m"
fi

exit
