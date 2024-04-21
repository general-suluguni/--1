#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Некорректные входные данные! Пожалуйста, введите два аргумента."
    exit 1
fi

inp_dir="$1"
outp_dir="$2"

if [ ! -d "$inp_dir" ]; then
    echo "Некорректные входные данные! Не существует директории: $inp_dir"
    exit 1
fi

if [ ! -d "$outp_dir" ]; then
    echo "Некорректные входные данные! Не существует директории: $outp_dir"
    exit 1
fi


deal_with_clones() { #функция, котораяя вызывается при наличии файлов с одинаковым названием, она изменяет название одного из файлов до тех пор, пока оно не станет униикальным, и перемещает его в выходную директорию
    local file="$1"
    local new_name="$2"
    i=1
    clone_name="${new_name%.*}_$i.${new_name##*.}"
    while [ -e "$clone_name" ]; do
        clone_name="${new_name%.*}_$i.${new_name##*.}"
        let i++
    done
    cp "$file" "$clone_name"
}

find "$inp_dir" -type f | while read -r file; do #считываются файлы из входной директории, при наличии файлов с одинаковыми названиями вызывает deal_with_clones, иначе - копирует файлы
    init_name=$(basename -- "$file")
    new_name="$outp_dir/$init_name"
    if [ -e "$new_name" ]; then
        deal_with_clones "$file" "$new_name"
    else
        cp "$file" "$new_name"
    fi
done

echo "Все файлы из $inp_dir скопированы в $outp_dir"