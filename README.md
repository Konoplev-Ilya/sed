# sed
on_perfomance.sh
==================
Читаем журнал на исполнении.
### аргументы 1-3: ### 
 - логин 
 - пасс 
 - имя_базы(из url)
### опционально 4 и 5 аргументы: ### 
 - дата(новее не читать. по умолчанию: 01.08.2021)
 - количество_документов_в_партии(умолчание - 100)
## пример: ##
   bash ./on_perfomance.sh login pass minsk 10.07.2021 1000

