#!/bin/bash
#By GoodMan850

i=0
while [ $i -lt 30 ]; do 
php /var/www/html/kill.php &
  sleep 2
  i=$(( i + 1 ))
done
