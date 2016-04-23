#!/bin/bash
while ! exec 6<>/dev/tcp/$MYSQL_PORT_3306_TCP_ADDR/$MYSQL_PORT_3306_TCP_PORT 
do
  echo "$(date) - still trying"
  sleep 1
done
cd /Netdot && make installdb && echo "GRANT ALL ON netdot.* TO netdot_user@'%' IDENTIFIED BY 'netdot_pass' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -uadmin -h$MYSQL_PORT_3306_TCP_ADDR -pmysql-server && touch /netdotinitdone
