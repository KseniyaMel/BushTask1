#!/bin/bash

rm -f ./output.xls #удаление файла, если он есть
echo -e "Название файла\tРасширение\tВес\tДата изменения\tДлительность\t\t" >> output.xls #название столбцов

function filesInfo {
	if [ "$(ls -A "$1" 2> /dev/null)" == "" ] #проверка на наличие директории или файла с таким названием
	then	
	return 
	else
	for curFile in "$1"/* # перебор файлов и деректорий
	do
		fileNameAbs="${curFile##*/}" # имя файла из абсолютного пути
		if [[ -d $curFile ]] # проверка на директорию
		then
			filesInfo "$curFile"
		elif [[ -f $curFile ]] #проверка на файл
		then
			fileName="${fileNameAbs%.[^.]*}" #название файла
			fileExtension="${fileNameAbs##*.}" #расширение файла
			fileSize=$(wc -c < "$curFile" | awk '{print $1}') #размер файла

			fileDataOfChange=$(date +%Y-5m-5d -r "$curFile") #дата изменения файла
			duration=$(mediainfo --Inform="General;%Duration%" $curFile) #длительность медиафайлов
			let "fileDuration = duration / 1000" #перевод длительности в секунды
			echo -e "$fileName \t $fileExtension \t $fileSize \t $fileDataOfChange \t $fileDuration" >> output.xls #вывод данных
		fi
	done
fi
}

echo "ВВедите путь к каталогу:"
read input
if [ -d $input ]
then
filesInfo "$input" #инициализация функции
else
	echo "Неверная директория"
fi

хуй
