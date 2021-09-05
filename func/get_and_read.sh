#!/bin/bash

get_and_read(){
    echo "от $4 и до бесконечного прошлого"
    echo "по $5 документов на странице"

    first=$(curl -s -u $1:$2  -d "_search=false&nd=1630323606058&rows=$5&page=1&sidx=dr&sord=asc&filter=36&search=true&dateFilterTo=$4" -X POST "http://198.19.0.6/csp/$3/json.$6.cls")
    
    if ! echo "$first" | grep -q rows ; then
        if echo "$first" | grep -q 'ОШИБКА #822: Отказано в доступе' ; then
            echo "$1 неверный пароль? ОШИБКА #822: Отказано в доступе"
            return -6
        fi
    echo -ne '\r\n'
    echo 'сервак отвечает невнятное'
    exit 1
    fi

    last_page=$(echo $first | jq .total | sed -e "s/^.//;s/.$//")
    total_doc_counter=0

    for i in $(seq 1 $last_page)
    do
    json=$(curl -s -u $1:$2  -d "_search=false&nd=1630242778381&rows=$5&page=$i&sidx=dr&sord=desc&dateFilterTo=$4&search=true" -X POST "http://198.19.0.6/csp/$3/json.$6.cls")

    if ! echo "$json" | grep -q rows ; then
        echo -ne '\r\n'
        echo 'сервак отвечает невнятное'
        exit 1
    fi

    count_to_view=$(echo $json | jq '.rows[] | select(.viewed == "0") | .id' | wc -l)
    docs_id_on_page=$(echo $json | jq '.rows[] | select(.viewed == "0") | .id' | sed -e "s/^.//;s/.$//")
    counter=0

    echo -ne "[login:$1][страница $i из $last_page]" "[документов прочитано $counter из $count_to_view]\r"

    for a in $docs_id_on_page
    do
        counter=$(($counter+1))
        echo -ne "[login:$1][страница $i из $last_page]" "[документов прочитано $counter из $count_to_view]\r"
        res=$(curl -s -u $1:$2 -d "oper=viewed&id=$a" -X GET http://198.19.0.6/csp/$3/json.$6.cls)

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
}