#!/bin/bash

rm -f ./output.xls
echo -e "Название файла\tРасширение\tВес\tДата изменения\tДлительность\t\t" >> output.xls

function filesInfo {
	for curFile in "$1"/*
	do
		fileNameAbs="${curFile##*/}"
		if [ -d "$curFile" ]
		then
			filesInfo "$curFile"
		else 
			fileName="${fileNameAbs%.[^.]*}"
			fileExtension="${fileNameAbs##*.}"
			fileSize=$(wc -c < "$curFile" | awk '{print $1}')

			if [[ "$fileName" == "*" ]]
			then 
				fileName="$curFile"
				fileExtension="пустая папка"
				fileSize="0"
			fi

			fileDataOfChange=$(stat -c %y $curFile)
			duration=$(mediainfo --Inform="General;%Duration%" $curFile)
			let "fileDuration = duration / 1000"
			echo -e "$fileName \t $fileExtension \t $fileSize \t $fileDataOfChange \t $fileDuration" >> output.xls
		fi
	done

}

echo "ВВедите путь к каталогу:"
read input
filesInfo "$input"