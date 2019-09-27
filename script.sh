#!/bin/bash

rm -f ./output.xls
echo -e "Название файла\tРасширение\tВес\tДата изменения\tДлительность\t\t" >> output.xls

function filesInfo {
	if [ "$(ls -A "$1" 2> /dev/null)" == "" ]
	then return
	else
	for curFile in "$1"/*
	do
		fileNameAbs="${curFile##*/}"
		if [[ -d $curFile ]]
		then
			filesInfo "$curFile"
		elif [[ -f $curFile ]]
		then
			fileName="${fileNameAbs%.[^.]*}"
			fileExtension="${fileNameAbs##*.}"
			fileSize=$(wc -c < "$curFile" | awk '{print $1}')

			if [[ "$fileName" == "*" ]]
			then 
				fileName="$curFile"
				fileExtension="пустая папка"
				fileSize="0"
			fi

			fileDataOfChange=$(date +%Y-5m-5d -r "$curFile")
			duration=$(mediainfo --Inform="General;%Duration%" $curFile)
			let "fileDuration = duration / 1000"
			echo -e "$fileName \t $fileExtension \t $fileSize \t $fileDataOfChange \t $fileDuration" >> output.xls
		fi
	done
fi
}

echo "ВВедите путь к каталогу:"
read input
filesInfo "$input"