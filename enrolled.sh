#!/bin/bash
source ./func/get_and_read.sh

date_filter=01.08.2021
doc_on_page=100

if [ $4 ] ; then
   date_filter=$4
fi

if [ $5 ] ; then
  doc_on_page=$5
fi

#$6 pcrec - enrolled.sh

get_and_read $1 $2 $3 $date_filter $doc_on_page pcrec