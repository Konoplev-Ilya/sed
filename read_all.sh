#!/bin/bash
source ./func/get_and_read.sh

date_filter=01.08.2021
doc_on_page=10000

while getopts "f:" opt
do
    case $opt in
        f) echo "берем логины и пароли из $OPTARG"
            file="$OPTARG"
            shift
            shift
            ;;
    esac
done

if [ -n "$file" ] ; then
    region=$1
    if [ $2 ] ; then
       date_filter=$4
    fi

    if [ $3 ] ; then
        doc_on_page=$5
    fi

    while IFS= read -r line
    do
        read login pass <<< "$line"
        get_and_read $login $pass $region $date_filter $doc_on_page pcexe
        get_and_read $login $pass $region $date_filter $doc_on_page pcrec
    done < $file
else
    if [ $4 ] ; then
        date_filter=$4
    fi

    if [ $5 ] ; then
        doc_on_page=$5
    fi
    get_and_read $1 $2 $3 $date_filter $doc_on_page pcexe
    get_and_read $1 $2 $3 $date_filter $doc_on_page pcrec
fi