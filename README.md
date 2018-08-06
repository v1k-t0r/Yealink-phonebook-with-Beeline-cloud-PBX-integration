# Yealink-phonebook-with-Beeline-cloud-PBX-integration
За основу взят скрипт https://github.com/wraythezw/RandomScripts/blob/master/yealink-freepbx-phonebook.sh
Понадобяться:
  - Apache c веб каталогом /var/www/html
  - jq https://stedolan.github.io/jq

Настройка:
1. Создать токен по адресу https://cloudpbx.beeline.ru/#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B8
2. Заменить в скрипте $YOUR_TOKEN_THERE на полученный токен
3. В облачной АТС занести ФИО, должность, короткий номер
4. В веб интерфейсе телефона по адресу http://telephone_ip/servlet?m=mod_data&p=contacts-remote&q=load добавить удаленную книгу по пути http://ip_веб_сервера/phonebook.xml
5. Скрипт добавить в crontab для периодической синхронизации телефонной книги с облачной АТС.
