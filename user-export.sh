#!/bin/bash

mysql --user="erichs" --password="gore2000" wordpressdb -e "SELECT * FROM wppl_friends_locator" -B | sed 's/\t/,/g' > /agmesh-scenarios/dmine-wppl-friends.csv;
mysql --user="erichs" --password="gore2000" wordpressdb -e "select * from wp_users" -B | sed 's/\t/,/g' > /agmesh-scenarios/dmine-users.csv;


