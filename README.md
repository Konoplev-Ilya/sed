# sed

## read_all.sh
читаем из 2 журналов. опция -f к файлу с логинами и паролями, разделенными пробелом, по одной паре в строке

---
    bash ./read_all.sh -f passwd.txt kleck

## enrolled.sh
Читаем журнал поступившие.
## on_perfomance.sh
Читаем журнал на исполнении.  

---
##### аргументы 1-3:  

 1. логин 
 2. пасс 
 3. имя базы (из url)  

опционально 4 и 5 аргументы:  

 4. дата (новее не читать. по умолчанию: 01.08.2021)
 5. количество документов в партии
---
    bash ./on_perfomance.sh login pass minsk  
---
    bash ./enrolled.sh login pass minsk 10.07.2021 1000

## notification_to_telegram.py
Уведомления в телеграм.

Свой телеграм токен прописать в файл config.py

Аргументы 

 1. -f имя_файла с логинами, паролями, id в телеграме
 2. -r регион

 #### Пример:
     python notification_to_telegram.py -f file.txt -r soligorsk
