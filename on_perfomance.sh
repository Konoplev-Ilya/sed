#!/bin/bash

date_filter=01.08.2021
doc_on_page=100

if [ $4 ] ; then
   date_filter=$4
fi

if [ $5 ] ; then
  doc_on_page=$5
fi

echo "от $date_filter и до бесконечного прошлого"
echo "по $doc_on_page документов на странице"

first=$(curl -s -u $1:$2  -d "_search=false&nd=1630323606058&rows=$doc_on_page&page=1&sidx=dr&sord=asc&filter=36&search=true&dateFilterTo=$date_filter" -X POST "http://198.19.0.6/csp/$3/json.pcexe.cls")
last_page=$(echo $first | jq .total | sed -e "s/^.//;s/.$//")
total_doc_counter=0

if ! echo "$first" | grep -q rows ; then
  echo -ne '\r\n'
  echo 'сервак отвечает невнятное'
  exit 1
fi

for i in $(seq 1 $last_page)
do
  json=$(curl -s -u $1:$2  -d "_search=false&nd=1630242778381&rows=$doc_on_page&page=$i&sidx=dr&sord=desc&dateFilterTo=$date_filter&search=true" -X POST "http://198.19.0.6/csp/$3/json.pcexe.cls")

  if ! echo "$json" | grep -q rows ; then
    echo -ne '\r\n'
    echo 'сервак отвечает невнятное'
    exit 1
  fi

  count_to_view=$(echo $json | jq '.rows[] | select(.viewed == "0") | .id' | wc -l)
  docs_id_on_page=$(echo $json | jq '.rows[] | select(.viewed == "0") | .id' | sed -e "s/^.//;s/.$//")
  counter=0

  echo -ne "[страница $i из $last_page]" "[документов прочитано $counter из $count_to_view]\r"

  for a in $docs_id_on_page
  do
    counter=$(($counter+1))
    echo -ne "[страница $i из $last_page]" "[документов прочитано $counter из $count_to_view]\r"
    res=$(curl -s -u $1:$2 -d "oper=viewed&id=$a" -X GET http://198.19.0.6/csp/$3/json.pcexe.cls)

    if ! echo "$res" | grep -q true ; then
      echo -ne '\r\n'
      echo 'сервак отвечает невнятное'
      exit 1
    fi

    #sleep 5
  done
  total_doc_counter=$(($total_doc_counter+$counter))
  echo -ne '\n'
done

echo 'total time in seconds: ' $SECONDS
echo 'total documents read: ' $total_doc_counter
