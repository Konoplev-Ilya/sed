# sed
## on_perfomance.sh
Читаем журнал на исполнении.
аргументы 1-3:  

 1. логин 
 2. пасс 
 3. имя_базы(из url)
опционально 4 и 5 аргументы:  

 4. дата(новее не читать. по умолчанию: 01.08.2021)
 5. количество_документов_в_партии(умолчание - 100)
## пример:
   bash ./on_perfomance.sh login pass minsk 10.07.2021 1000

